import 'package:dependency_plugin/dependency_plugin.dart';
import 'package:efapp/presentation/global_widgets/default_firebase_image_provider.dart';
import 'package:efapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GalleryAlbumImagesView extends StatefulWidget {
  final GalleryMd model;
  const GalleryAlbumImagesView({Key? key, required this.model})
      : super(key: key);

  @override
  State<GalleryAlbumImagesView> createState() => _GalleryAlbumImagesViewState();
}

class _GalleryAlbumImagesViewState extends State<GalleryAlbumImagesView> {
  final ScrollController _scrollController = ScrollController();
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      //when the page changes, scroll the preview to the current page
      _scrollController.jumpTo(
        _pageController.page! * 100.w,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<GalleryImageMd>>(
      stream: DependencyManager.instance.firestore.galleryImagesQuery
          .where('gallery_id', isEqualTo: widget.model.id)
          .orderBy("created_at", descending: true)
          .withConverter(fromFirestore: (snapshot, options) {
        final data = snapshot.data()!;
        return GalleryImageMd.fromMap(data);
      }, toFirestore: (value, options) {
        return value.toMap();
      }).snapshots(),
      builder: (context, snapshot) {
        //loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        //error
        if (snapshot.hasError) {
          return Text('error ${snapshot.error}');
        }
        //empty
        if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No images'));
        }
        //data
        final images = snapshot.data!.docs.map((e) => e.data()).toList();

        return Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: images.length,
              itemBuilder: (context, index) {
                final image = images[index];
                return InteractiveViewer(
                  child: Image(
                    image: DefaultCachedFirebaseImageProvider(image.imagePath),
                  ),
                );
              },
            ),
            //build a preview of the images in small boxes at the bottom
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 80.h,
                color: Colors.black.withOpacity(0.5),
                child: Scrollbar(
                  thumbVisibility: true,
                  controller: _scrollController,
                  child: ListView.separated(
                    controller: _scrollController,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8)
                            .w,
                    separatorBuilder: (context, index) => SizedBox(width: 16.w),
                    scrollDirection: Axis.horizontal,
                    itemCount: images.length,
                    itemBuilder: (context, index) {
                      final image = images[index];
                      return GestureDetector(
                        onTap: () {
                          _pageController.animateToPage(index,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut);
                        },
                        child: SizedBox(
                          width: 100.w,
                          child: Image(
                            fit: BoxFit.cover,
                            image: DefaultCachedFirebaseImageProvider(
                                image.imagePath),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            //create a title for the album title with back button
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 60.h,
                color: Colors.black.withOpacity(0.5),
                child: Row(
                  children: [
                    IconButton(
                      color: Colors.white,
                      onPressed: () {
                        context.pop();
                      },
                      icon: const Icon(Icons.arrow_back),
                    ),
                    Text(
                      widget.model.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
