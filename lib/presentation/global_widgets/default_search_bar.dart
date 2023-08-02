// ignore_for_file: use_build_context_synchronously

import 'package:dependency_plugin/dependency_plugin.dart';
import 'package:efapp/manager/manager.dart';
import 'package:efapp/manager/ytmusic/downlod.dart';
import 'package:efapp/presentation/global_widgets/modals/yt_popup.dart';
import 'package:efapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Can search book, blog, video

class DefaultSearchBar extends StatefulWidget {
  const DefaultSearchBar({super.key});

  @override
  State<DefaultSearchBar> createState() => _DefaultSearchBarState();
}

class _DefaultSearchBarState extends State<DefaultSearchBar> {
  final blogsQuery =
      FirebaseFirestore.instance.collection(FirestoreDep.blogsCn).withConverter(
    fromFirestore: (snapshot, options) {
      final data = snapshot.data()!;
      return BlogMd.fromMap(data);
    },
    toFirestore: (value, options) {
      return value.toMap();
    },
  );
  final booksQuery =
      FirebaseFirestore.instance.collection(FirestoreDep.booksCn);
  final videosQuery = FirebaseFirestore.instance
      .collection(FirestoreDep.ytVideosCn)
      .withConverter(
    fromFirestore: (snapshot, options) {
      final data = snapshot.data()!;
      return YtVideoMd.fromMap(data);
    },
    toFirestore: (value, options) {
      return value.toMap();
    },
  );

  final list = <Map<String, dynamic>>[];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.endOfFrame.then((_) async {
      final snapshot = await blogsQuery.get();
      for (final item in snapshot.docs) {
        list.add({
          "id": item.data().id,
          "title": item.data().title,
          "isBlog": true,
        });
      }

      final snapshot2 = await booksQuery.get();
      for (final item in snapshot2.docs) {
        list.add({
          "url": item.data()["url"],
          "title": item.data()["title"],
          "isBook": true,
        });
      }

      final snapshot3 = await videosQuery.get();
      for (final item in snapshot3.docs) {
        list.add({
          "title": item.data().title,
          "videoId": item.data().videoId,
          "isVideo": true,
        });
      }
    });
  }

  void updateUI() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: SearchAnchor.bar(
          barHintText: 'Search',
          isFullScreen: false,
          barBackgroundColor: MaterialStateProperty.all(
              Theme.of(context).scaffoldBackgroundColor),
          barElevation: MaterialStateProperty.all(0),
          barSide: MaterialStateBorderSide.resolveWith((states) =>
              BorderSide(color: context.colorScheme.primary.withOpacity(.4))),
          barHintStyle: MaterialStateProperty.all(Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(color: context.colorScheme.primary)),
          barLeading: Icon(Icons.search, color: context.colorScheme.primary),
          suggestionsBuilder: (context, controller) {
            final newList = <Map<String, dynamic>>[];
            for (final item in list) {
              if (item["title"]
                  .toString()
                  .toLowerCase()
                  .contains(controller.text.toLowerCase())) {
                newList.add(item);
              }
            }
            return [
              for (int i = 0; i < newList.length; i++)
                SearchSuggestion(
                  title: _getTitle(newList[i]),
                  onTap: () {
                    final item = newList[i];
                    controller.text = item["title"];
                    controller.closeView(null);
                    if (item['isBook'] == true) {
                      context.goToWebView(item["url"]);
                    } else if (item['isVideo'] == true) {
                      context.futureLoading(() async {
                        final video = await videosQuery
                            .where("youtube_video_id",
                                isEqualTo: item["videoId"])
                            .get();
                        if (video.docs.isEmpty) return;
                        context.openWithHeroAnimation(
                            YtPopup(item: video.docs.first.data()));
                      });
                    } else if (item['isBlog'] == true) {
                      context.futureLoading(() async {
                        logger(" ${item["id"]}");
                        final blog = await blogsQuery
                            .where("id", isEqualTo: item["id"])
                            .get();
                        logger("blog ${blog.docs.length}");
                        if (blog.docs.isEmpty) return;
                        context.push(
                            "${MCANavigation.home}${MCANavigation.blogs}/${blog.docs.first.id}",
                            extra: blog.docs.first.data());
                      });
                    }
                  },
                ),
            ];
          }),
    );
  }

  String _getTitle(Map<String, dynamic> item) {
    String head = "";
    if (item['isBook'] == true) {
      head = "Book: ";
    } else if (item['isVideo'] == true) {
      head = "Video: ";
    } else if (item['isBlog'] == true) {
      head = "Blog: ";
    }
    return head + item["title"];
  }
}

class SearchSuggestion extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const SearchSuggestion({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
    );
  }
}
