import 'package:dependency_plugin/dependencies/dependencies.dart';
import 'package:dependency_plugin/dependency_plugin.dart';
import 'package:efapp/manager/manager.dart';
import 'package:efapp/presentation/global_widgets/widgets.dart';
import 'package:efapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';

class BlogsListView extends StatelessWidget {
  const BlogsListView({super.key});

  @override
  Widget build(BuildContext context) {
    return SpacedColumn(
      verticalSpace: 16.h,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Row(
            children: [
              Text("New Blogs",
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall!
                      .copyWith(color: Colors.black)),
              const Spacer(),
              ElevatedButton(
                  onPressed: () {
                    context.go("${MCANavigation.home}${MCANavigation.blogs}");
                  },
                  child: const Text("See All"))
            ],
          ),
        ),
        const _NewBlogsListView(),
      ],
    );
  }
}

class _NewBlogsListView extends StatelessWidget {
  const _NewBlogsListView();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 138.h,
      child: FirestoreQueryBuilder<BlogMd>(
        query: FirebaseFirestore.instance
            .collection(FirestoreDep.blogsCn)
            .orderBy("created_at", descending: true)
            .withConverter(
          fromFirestore: (snapshot, options) {
            final data = snapshot.data()!;
            return BlogMd.fromMap(data);
          },
          toFirestore: (value, options) {
            return value.toMap();
          },
        ),
        builder: (context, snapshot, child) {
          if (snapshot.isFetching) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text("Error fetching data"));
          }
          final len = snapshot.docs.length > 5 ? 5 : snapshot.docs.length;
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
                      context.go("${MCANavigation.home}${MCANavigation.blogs}");
                    },
                    icon: const Icon(Icons.arrow_forward_ios),
                  ),
                );
              }
              final model = snapshot.docs[index].data();
              return _BlogWidget(model: model);
            },
          );
        },
      ),
    );
  }
}

class _BlogWidget extends StatelessWidget {
  final BlogMd model;

  const _BlogWidget({required this.model});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(8.r),
        child: SizedBox(
          width: 91.w,
          child: GestureDetector(
            onTap: () {
              context.push(
                  "${MCANavigation.home}${MCANavigation.blogs}/${model.id}",
                  extra: model);
            },
            child: Hero(
              tag: model.id,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: DefaultCachedFirebaseImageProvider(model.imagePath),
                    fit: BoxFit.fitHeight,
                  ),
                  color: context.colorScheme.primary,
                ),
                // child: model.imagePath.isEmpty
                //     ? Center(
                //         child: Text(model.title,
                //             maxLines: 4,
                //             overflow: TextOverflow.ellipsis,
                //             textAlign: TextAlign.center,
                //             style: Theme.of(context)
                //                 .textTheme
                //                 .headlineSmall!
                //                 .copyWith(
                //                     color: Colors.white, fontSize: 14.sp)),
                //       )
                //     : Image(
                //         errorBuilder: (context, error, stackTrace) {
                //           return Center(
                //             child: Text(model.title,
                //                 maxLines: 4,
                //                 overflow: TextOverflow.ellipsis,
                //                 textAlign: TextAlign.center,
                //                 style: Theme.of(context)
                //                     .textTheme
                //                     .headlineSmall!
                //                     .copyWith(
                //                         color: Colors.white, fontSize: 14.sp)),
                //           );
                //         },
                //         loadingBuilder: (context, child, loadingProgress) {
                //           if (loadingProgress == null) return child;
                //           return const Center(
                //             child: CircularProgressIndicator(),
                //           );
                //         },
                //         fit: BoxFit.fitHeight,
                //         image:
                //             DefaultCachedFirebaseImageProvider(model.imagePath),
                //       ),
              ),
            ),
          ),
        ));
  }
}
