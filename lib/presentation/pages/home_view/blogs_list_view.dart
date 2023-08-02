import 'package:dependency_plugin/dependencies/dependencies.dart';
import 'package:dependency_plugin/dependency_plugin.dart';
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
              ElevatedButton(onPressed: () {}, child: const Text("See All"))
            ],
          ),
        ),
        _NewBlogsListView(),
      ],
    );
  }
}

class _NewBlogsListView extends StatelessWidget {
  const _NewBlogsListView();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150.h,
      child: FirestoreListView<BlogMd>(
        query: FirebaseFirestore.instance
            .collection(FirestoreDep.blogsCn)
            .orderBy("createdDate", descending: true)
            .limit(4)
            .withConverter(
          fromFirestore: (snapshot, options) {
            final data = snapshot.data()!;
            return BlogMd.fromMap(data);
          },
          toFirestore: (value, options) {
            return value.toMap();
          },
        ),
        padding: EdgeInsets.only(left: 24.w),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, snapshot) {
          final model = snapshot.data();
          return BookWidget(model: model);
        },
      ),
    );
  }
}

class BookWidget extends StatelessWidget {
  final BlogMd model;
  const BookWidget({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 16.w),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.r),
        child: SizedBox(
          height: 150.h,
          width: 91.w,
          child: GestureDetector(
            onTap: () {
              //todo:
              // launchURL(model.url);
            },
            child: DecoratedBox(
                decoration: BoxDecoration(color: context.colorScheme.primary),
                child:
                    // model.imageUrl.isEmpty
                    //     ?
                    Center(
                  child: Text(model.title,
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall!
                          .copyWith(color: Colors.white, fontSize: (16).sp)),
                )
                //todo:
                // : CachedNetworkImage(
                //     imageUrl: model.imageUrl,
                //     fit: BoxFit.fill,
                //     placeholder: (context, url) => const Center(
                //       child: CircularProgressIndicator(),
                //     ),
                //     errorWidget: (context, url, error) =>
                //         const Icon(Icons.error),
                //   ),
                ),
          ),
        ),
      ),
    );
  }
}
