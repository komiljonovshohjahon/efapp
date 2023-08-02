import 'package:dependency_plugin/dependency_plugin.dart';
import 'package:efapp/presentation/global_widgets/widgets.dart';
import 'package:efapp/presentation/pages/blogs_view/main_blog_widget.dart';
import 'package:efapp/utils/global_functions.dart';
import 'package:efapp/utils/utils.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BlogsView extends StatefulWidget {
  const BlogsView({super.key});

  @override
  State<BlogsView> createState() => _BlogsViewState();
}

class _BlogsViewState extends State<BlogsView> {
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
          .getCollectionBasedListFuture<BlogMd>(
        collection: FirestoreDep.blogsCn,
        fromJson: (p0) {
          return BlogMd.fromMap(p0);
        },
      );
      if (res.isRight) return;
      if (res.isLeft) {
        final data = res.left;
        for (var element in data) {
          if (!dates.contains(element.substr_date)) {
            dates.add(element.substr_date);
          }
        }
        dates.sort((a, b) => b.compareTo(a));
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
          child: FirestoreQueryBuilder<BlogMd>(
            query: FirestoreDep.instance.blogsQuery
                .where("substr_date", isEqualTo: selectedDate?.title)
                .orderBy('created_at', descending: true)
                .withConverter(
              fromFirestore: (snapshot, options) {
                final data = snapshot.data()!;
                return BlogMd.fromMap(data);
              },
              toFirestore: (value, options) {
                return value.toMap();
              },
            ),
            builder: (context, snapshot, _) {
              if (snapshot.isFetching) {
                return const CircularProgressIndicator();
              }
              if (snapshot.hasError) {
                return Text('error ${snapshot.error}');
              }

              return ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                itemCount: snapshot.docs.length,
                itemBuilder: (context, index) {
                  // if we reached the end of the currently obtained items, we try to
                  // obtain more items
                  if (snapshot.hasMore && index + 1 == snapshot.docs.length) {
                    // Tell FirestoreQueryBuilder to try to obtain more items.
                    // It is safe to call this function from within the build method.
                    snapshot.fetchMore();
                  }

                  final blog = snapshot.docs[index].data();
                  if (index == 0) {
                    return MainBlogWidget(blog: blog);
                  }
                  return Text(blog.title);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
