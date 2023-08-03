import 'package:dependency_plugin/dependency_plugin.dart';
import 'package:efapp/manager/routes.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'gallery_card_widget.dart';

class GalleryAlbumView extends StatefulWidget {
  const GalleryAlbumView({super.key});

  @override
  State<GalleryAlbumView> createState() => _GalleryAlbumViewState();
}

class _GalleryAlbumViewState extends State<GalleryAlbumView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverFillRemaining(
          child: FirestoreQueryBuilder<GalleryMd>(
            query: FirestoreDep.instance.galleryQuery
                .orderBy('created_at', descending: true),
            builder: (context, snapshot, _) {
              if (snapshot.isFetching) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Text('error ${snapshot.error}');
              }

              return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 16.h,
                      crossAxisSpacing: 16.w),
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                  itemCount: snapshot.docs.length,
                  itemBuilder: (context, index) {
                    if (snapshot.hasMore && index + 1 == snapshot.docs.length) {
                      snapshot.fetchMore();
                    }

                    final model = snapshot.docs[index].data();
                    return GalleryCardWidget(model: model);
                  });
            },
          ),
        ),
      ],
    );
  }

  void gotoBlogDetail(GalleryMd blog) {
    context.go("${MCANavigation.home}/${MCANavigation.blogs}:${blog.id}",
        extra: blog);
  }
}
