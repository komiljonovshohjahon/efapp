import 'package:dependency_plugin/dependency_plugin.dart';
import 'package:efapp/manager/routes.dart';
import 'package:efapp/manager/ytmusic/nav.dart';
import 'package:efapp/presentation/global_widgets/widgets.dart';
import 'package:efapp/presentation/pages/blogs_view/blog_card_widget.dart';
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
  // DefaultMenuItem? selectedDate;

  final List<String> dates = [];

  @override
  void initState() {
    super.initState();
    // fetchDates();
  }

  void fetchDates() {
    // context.futureLoading(() async {
    //   final res = await DependencyManager.instance.firestore
    //       .getCollectionBasedListFuture<BlogMd>(
    //     collection: FirestoreDep.blogsCn,
    //     fromJson: (p0) {
    //       return BlogMd.fromMap(p0);
    //     },
    //   );
    //   if (res.isRight) return;
    //   if (res.isLeft) {
    //     final data = res.left
    //       ..removeWhere((element) => element.date == null)
    //       ..sort((a, b) => b.date!.compareTo(a.date!));
    //     for (var element in data) {
    //       if (!dates.contains(element.substr_date)) {
    //         dates.add(element.substr_date);
    //       }
    //     }
    //     if (dates.isNotEmpty) {
    //       selectedDate = DefaultMenuItem(id: 0, title: dates[0]);
    //     }
    //     setState(() {});
    //   }
    // });
  }

  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: EdgeInsets.symmetric(vertical: 16.h),
          sliver: SliverAppBar(
            title: TextButton.icon(
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
            // DefaultDropdown(
            //   hasSearchBox: true,
            //   items: [
            //     for (int i = 0; i < dates.length; i++)
            //       DefaultMenuItem(id: i, title: dates[i]),
            //   ],
            //   onChanged: (value) {
            //     setState(() {
            //       selectedDate = value;
            //     });
            //   },
            //   valueId: selectedDate?.id,
            //   height: 48,
            // ),
            centerTitle: true,
            pinned: true,
            automaticallyImplyLeading: false,
          ),
        ),
        SliverFillRemaining(
          child: FirestoreQueryBuilder<BlogMd>(
            query: FirestoreDep.instance.blogsQuery
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
                    child: Text("No blogs!", style: TextStyle(fontSize: 24)));
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

                    final blog = snapshot.docs[index].data();
                    if (index == 0) {
                      return MainBlogWidget(blog: blog);
                    }
                    return BlogCardWidget(blog: blog);
                  });
            },
          ),
        ),
      ],
    );
  }

  void gotoBlogDetail(BlogMd blog) {
    context.go("${MCANavigation.home}/${MCANavigation.blogs}:${blog.id}",
        extra: blog);
  }
}
