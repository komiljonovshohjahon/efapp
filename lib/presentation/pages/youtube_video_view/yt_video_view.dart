// ignore_for_file: use_build_context_synchronously

import 'package:dependency_plugin/dependency_plugin.dart';
import 'package:efapp/manager/routes.dart';
import 'package:efapp/presentation/global_widgets/widgets.dart';
import 'package:efapp/presentation/pages/blogs_view/blog_card_widget.dart';
import 'package:efapp/presentation/pages/blogs_view/main_blog_widget.dart';
import 'package:efapp/presentation/pages/youtube_video_view/main_video_widget.dart';
import 'package:efapp/utils/global_functions.dart';
import 'package:efapp/utils/utils.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'video_card_widget.dart';

class YtVideoView extends StatefulWidget {
  final String? documentId;
  const YtVideoView({super.key, this.documentId});

  @override
  State<YtVideoView> createState() => _YtVideoViewState();
}

class _YtVideoViewState extends State<YtVideoView> {
  String? get documentId => widget.documentId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.endOfFrame.then((_) {
      context.futureLoading(() async {
        if (documentId != null) {
          final item = await DependencyManager.instance.firestore
              .findByCollectionAndDocumentId<YtVideoMd>(
                  collection: FirestoreDep.ytVideosCn,
                  documentId: documentId!,
                  fromJson: (p0) => YtVideoMd.fromMap(p0));
          if (item != null) {
            context.openWithHeroAnimation(YtPopup(item: item));
          } else {
            context.showError("Cannot find video");
          }
        }
      });
    });
  }

  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: TextButton.icon(
            onPressed: () {
              showCustomMonthPicker(context, initialTime: selectedDate)
                  .then((value) {
                if (value != null) {
                  setState(() {
                    selectedDate = value;
                  });
                }
              });
            },
            label: Text(DateFormat("MMM yyy").format(selectedDate)),
            icon: const Icon(Icons.calendar_today),
          ),
        ),
        SliverFillRemaining(
          child: FirestoreQueryBuilder<YtVideoMd>(
            query: FirestoreDep.instance.ytVideosQuery
                .where("substr_date",
                    isEqualTo: DateFormat("MMM yyy").format(selectedDate))
                .orderBy('created_at', descending: true),
            builder: (context, snapshot, _) {
              if (snapshot.isFetching) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Text('error ${snapshot.error}');
              }

              if (snapshot.docs.isEmpty) {
                return const Center(
                    child: Text("No videos!", style: TextStyle(fontSize: 24)));
              }

              return ListView.separated(
                  separatorBuilder: (context, index) {
                    return SizedBox(height: 6.h);
                  },
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  itemCount: snapshot.docs.length,
                  itemBuilder: (context, index) {
                    if (snapshot.hasMore && index + 1 == snapshot.docs.length) {
                      snapshot.fetchMore();
                    }

                    final model = snapshot.docs[index].data();
                    if (index == 0) {
                      return MainVideoWidget(model: model);
                    }
                    return VideoCardWidget(model: model);
                  });
            },
          ),
        ),
      ],
    );
  }
}
