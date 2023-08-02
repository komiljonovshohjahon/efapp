import 'package:dependency_plugin/dependency_plugin.dart';
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
      FirebaseFirestore.instance.collection(FirestoreDep.blogsCn);
  final booksQuery =
      FirebaseFirestore.instance.collection(FirestoreDep.booksCn);

  final list = <Map<String, dynamic>>[];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.endOfFrame.then((_) async {
      final snapshot = await blogsQuery.get();
      for (final item in snapshot.docs) {
        list.add({
          "id": item.id,
          "title": item.data()["title"],
          "isBook": false,
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
    });
  }

  void updateUI() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
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
                  title: newList[i]["title"],
                  onTap: () {
                    final item = newList[i];
                    controller.text = item["title"];
                    controller.closeView(null);
                    if (item['isBook']) {
                      launchURL(item["url"]);
                    }
                  },
                ),
            ];
          }),
    );
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
    );
  }
}
