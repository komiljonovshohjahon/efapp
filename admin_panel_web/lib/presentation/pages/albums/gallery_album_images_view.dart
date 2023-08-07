// ignore_for_file: use_build_context_synchronously

import 'package:admin_panel_web/presentation/global_widgets/default_firebase_image_provider.dart';
import 'package:admin_panel_web/utils/utils.dart';
import 'package:dependency_plugin/dependency_plugin.dart';
import 'package:flutter/material.dart';

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
    // _pageController.addListener(() {
    //when the page changes, scroll the preview to the current page
    // _scrollController.jumpTo(
    //   _pageController.page! * 100,
    // );
    // });
  }

  GalleryImageMd? _selectedImage;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<GalleryImageMd>>(
      stream: DependencyManager.instance.firestore.galleryImagesQuery
          .where('gallery_id', isEqualTo: widget.model.id)
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

        //data
        final images = snapshot.data!.docs.map((e) => e.data()).toList();

        return Stack(
          children: [
            if (images.isEmpty)
              const Center(child: Text("No images in this album")),
            PageView.builder(
              controller: _pageController,
              itemCount: images.length,
              itemBuilder: (context, index) {
                final image = images[index];
                print(image.imagePath);
                return InteractiveViewer(
                  child: Image(
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      _selectedImage = images[index];
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
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
                height: 80,
                color: context.colorScheme.primary,
                child: Scrollbar(
                  thumbVisibility: true,
                  controller: _scrollController,
                  child: ListView.separated(
                    controller: _scrollController,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 16),
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
                          width: 100,
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
                height: 60,
                color: context.colorScheme.primary,
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
                    const Spacer(),
                    TextButton.icon(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                      ),
                      onPressed: update,
                      icon: const Icon(Icons.edit),
                      label: const Text('Replace'),
                    ),
                    //delete icon button
                    TextButton.icon(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                      ),
                      onPressed: delete,
                      icon: const Icon(Icons.delete),
                      label: const Text('Delete'),
                    ),
                    TextButton.icon(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                      ),
                      onPressed: create,
                      icon: const Icon(Icons.add),
                      label: const Text('Add Image'),
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

  void create() {
    pickFile().then((value) {
      if (value == null) return;
      context.futureLoading(() async {
        final res = await DependencyManager.instance.firestore
            .createOrUpdateGalleryImage(
                model:
                    GalleryImageMd.init().copyWith(galleryId: widget.model.id),
                image: value.firstOrNull?.bytes);
        if (res.isRight) {
          setState(() {});
        } else if (res.isLeft) {
          context.showError(res.left);
        } else {
          context.showError("Unknown error");
        }
      });
    });
  }

  void update() {
    if (_selectedImage == null) {
      context.showError("Please select an image to replace");
      return;
    }
    pickFile().then((value) {
      if (value == null) return;
      context.futureLoading(() async {
        final res = await DependencyManager.instance.firestore
            .createOrUpdateGalleryImage(
                model: _selectedImage!.copyWith(galleryId: widget.model.id),
                image: value.firstOrNull?.bytes);
        if (res.isRight) {
          setState(() {});
        } else if (res.isLeft) {
          context.showError(res.left);
        } else {
          context.showError("Unknown error");
        }
      });
    });
  }

  void delete() {
    if (_selectedImage == null) {
      context.showError("Please select an image to delete");
      return;
    }
    context.futureLoading(() async {
      final res = await DependencyManager.instance.firestore
          .deleteGalleryImage(_selectedImage!.id);
      if (res.isRight) {
        setState(() {});
      } else if (res.isLeft) {
        context.showError(res.left);
      } else {
        context.showError("Unknown error");
      }
    });
  }
}
