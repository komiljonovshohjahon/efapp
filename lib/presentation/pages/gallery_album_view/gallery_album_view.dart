// ignore_for_file: use_build_context_synchronously

import 'package:dependency_plugin/dependency_plugin.dart';
import 'package:efapp/manager/routes.dart';
import 'package:efapp/utils/utils.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'gallery_card_widget.dart';

class GalleryAlbumView extends StatefulWidget {
  final String? galleryImageDocumentId;
  const GalleryAlbumView({super.key, this.galleryImageDocumentId});

  @override
  State<GalleryAlbumView> createState() => _GalleryAlbumViewState();
}

class _GalleryAlbumViewState extends State<GalleryAlbumView> {
  String? get galleryImageDocumentId => widget.galleryImageDocumentId;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.endOfFrame.then((_) {
      context.futureLoading(() async {
        if (galleryImageDocumentId != null) {
          final item = await DependencyManager.instance.firestore
              .findByCollectionAndDocumentId<GalleryImageMd>(
                  collection: FirestoreDep.galleryImagesCn,
                  documentId: galleryImageDocumentId!,
                  fromJson: (p0) => GalleryImageMd.fromMap(p0));
          if (item != null) {
            //find gallery album using gallery album id
            final docs = await DependencyManager.instance.firestore.fire
                .collection(FirestoreDep.galleryCn)
                .where("id", isEqualTo: item.galleryId)
                .get();
            if (docs.docs.isNotEmpty) {
              final model = GalleryMd.fromMap(docs.docs.first.data());
              context.goToGalleryAlbumImages(model);
              //go to album view
            }
          } else {
            context.showError("Cannot find image");
          }
        }
      });
    });
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
}
