// ignore_for_file: use_build_context_synchronously

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
  final String? documentId;
  const BlogsView({super.key, this.documentId});

  @override
  State<BlogsView> createState() => _BlogsViewState();
}

class _BlogsViewState extends State<BlogsView> {
  String? get documentId => widget.documentId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.endOfFrame.then((_) {
      context.futureLoading(() async {
        if (documentId != null) {
          final item = await DependencyManager.instance.firestore
              .findByCollectionAndDocumentId<BlogMd>(
                  collection: FirestoreDep.blogsCn,
                  documentId: documentId!,
                  fromJson: (p0) => BlogMd.fromMap(p0));
          if (item != null) {
            context.goToBlogDetails(item);
          } else {
            context.showError("Cannot find blog");
          }
        }
      });
    });
  }

  void fetchDates() {}

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
