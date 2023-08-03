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
  const YtVideoView({super.key});

  @override
  State<YtVideoView> createState() => _YtVideoViewState();
}

class _YtVideoViewState extends State<YtVideoView> {
  DefaultMenuItem? selectedDate;

  final List<String> dates = [];

  @override
  void initState() {
    super.initState();
    fetchDates();
  }

  void fetchDates() {
    context.futureLoading(() async {
      final res = await DependencyManager.instance.firestore
          .getCollectionBasedListFuture<YtVideoMd>(
        collection: FirestoreDep.ytVideosCn,
        fromJson: (p0) {
          return YtVideoMd.fromMap(p0);
        },
      );
      if (res.isRight) return;
      if (res.isLeft) {
        final data = res.left
          ..removeWhere((element) => element.date == null)
          ..sort((a, b) => b.date!.compareTo(a.date!));
        for (var element in data) {
          if (!dates.contains(element.substr_date)) {
            dates.add(element.substr_date);
          }
        }
        if (dates.isNotEmpty) {
          selectedDate = DefaultMenuItem(id: 0, title: dates[0]);
        }
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: EdgeInsets.symmetric(vertical: 16.h),
          sliver: SliverAppBar(
            title: DefaultDropdown(
              hasSearchBox: true,
              items: [
                for (int i = 0; i < dates.length; i++)
                  DefaultMenuItem(id: i, title: dates[i]),
              ],
              onChanged: (value) {
                setState(() {
                  selectedDate = value;
                });
              },
              valueId: selectedDate?.id,
              height: 48,
            ),
            centerTitle: true,
            pinned: true,
            automaticallyImplyLeading: false,
          ),
        ),
        SliverFillRemaining(
          child: FirestoreQueryBuilder<YtVideoMd>(
            query: FirestoreDep.instance.ytVideosQuery
                .where("substr_date", isEqualTo: selectedDate?.title)
                .orderBy('created_at', descending: true),
            builder: (context, snapshot, _) {
              if (snapshot.isFetching) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Text('error ${snapshot.error}');
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

  void gotoBlogDetail(YtVideoMd blog) {
    context.go("${MCANavigation.home}/${MCANavigation.blogs}:${blog.id}",
        extra: blog);
  }
}
