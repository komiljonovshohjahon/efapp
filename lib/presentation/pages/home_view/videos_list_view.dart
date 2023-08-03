import 'package:dependency_plugin/dependencies/dependencies.dart';
import 'package:dependency_plugin/dependency_plugin.dart';
import 'package:efapp/manager/manager.dart';
import 'package:efapp/presentation/global_widgets/widgets.dart';
import 'package:efapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:youtube/youtube_thumbnail.dart';

class VideosListView extends StatelessWidget {
  const VideosListView({super.key});

  @override
  Widget build(BuildContext context) {
    return SpacedColumn(
      verticalSpace: 16.h,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Row(
            children: [
              Text("Latest Videos",
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall!
                      .copyWith(color: Colors.black)),
              const Spacer(),
              ElevatedButton(
                  onPressed: () {
                    context.go("${MCANavigation.home}${MCANavigation.yt}");
                  },
                  child: const Text("See All"))
            ],
          ),
        ),
        const _NewVideosListView(),
      ],
    );
  }
}

class _NewVideosListView extends StatelessWidget {
  const _NewVideosListView();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90.h,
      child: StreamBuilder<QuerySnapshot<YtVideoMd>>(
        stream: FirebaseFirestore.instance
            .collection(FirestoreDep.ytVideosCn)
            .limit(5)
            .orderBy("created_at", descending: true)
            .withConverter(
          fromFirestore: (snapshot, options) {
            final data = snapshot.data()!;
            return YtVideoMd.fromMap(data);
          },
          toFirestore: (value, options) {
            return value.toMap();
          },
        ).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text("Error fetching data"));
          }
          if (snapshot.data == null) {
            return const Center(child: Text("No videos found"));
          }
          final len = snapshot.data!.docs.length;
          return ListView.separated(
            separatorBuilder: (context, index) => SizedBox(width: 16.w),
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            scrollDirection: Axis.horizontal,
            itemCount: len,
            itemBuilder: (context, index) {
              //if last index, show a arrow button to see all
              if (index == len - 1) {
                return Center(
                  child: IconButton(
                    onPressed: () {
                      context.go("${MCANavigation.home}${MCANavigation.yt}");
                    },
                    icon: const Icon(Icons.arrow_forward_ios),
                  ),
                );
              }
              final model = snapshot.data!.docs[index].data();
              return _VideoWidget(model: model);
            },
          );
        },
      ),
    );
  }
}

class _VideoWidget extends StatelessWidget {
  final YtVideoMd model;

  const _VideoWidget({required this.model});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(8.r),
        child: SizedBox(
          width: 91.w,
          child: GestureDetector(
            onTap: () {
              context.openWithHeroAnimation(YtPopup(item: model));

              // context.push(
              // "${MCANavigation.home}${MCANavigation.blogs}/${model.id}",
              // extra: model);
            },
            child: Hero(
              tag: model.id,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: context.colorScheme.primary,
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Image(
                        errorBuilder: (context, error, stackTrace) {
                          return const SizedBox();
                        },
                        alignment: Alignment.center,
                        image: NetworkImage(
                            YoutubeThumbnail(youtubeId: model.videoId).hq()),
                        fit: BoxFit.fill,
                      ),
                    ),
                    Center(
                      child: Container(
                        width: 20.r,
                        height: 20.r,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.r),
                          color: context.colorScheme.primary,
                        ),
                        child: Icon(
                          color: Colors.white,
                          size: 10.r,
                          Icons.play_arrow_sharp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
