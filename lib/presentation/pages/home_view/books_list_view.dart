import 'package:dependency_plugin/dependency_plugin.dart';
import 'package:efapp/presentation/global_widgets/widgets.dart';
import 'package:efapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';

class BooksListView extends StatelessWidget {
  const BooksListView({super.key});

  @override
  Widget build(BuildContext context) {
    return SpacedColumn(
      verticalSpace: 16.h,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Row(
            children: [
              Text("Latest Books",
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall!
                      .copyWith(color: Colors.black)),
              const Spacer(),
              ElevatedButton(
                  onPressed: () {
                    context.goToWebView(Urls.booksUrl);
                  },
                  child: const Text("See All"))
            ],
          ),
        ),
        const _NewBooksListView(),
      ],
    );
  }
}

class _NewBooksListView extends StatelessWidget {
  const _NewBooksListView();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200.h,
      child: StreamBuilder<QuerySnapshot<BookMd>>(
        stream: DependencyManager.instance.firestore.booksQuery
            .limit(5)
            .orderBy("createdDate", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text("Error fetching data"));
          }
          if (snapshot.data == null) {
            return const Center(child: Text("No books found"));
          }
          final len = snapshot.data!.docs.length;
          return ListView.separated(
            separatorBuilder: (context, index) => SizedBox(width: 16.w),
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            scrollDirection: Axis.horizontal,
            itemCount: len,
            itemBuilder: (context, index) {
              if (index == len - 1) {
                return Center(
                  child: IconButton(
                    onPressed: () {
                      context.goToWebView(Urls.booksUrl);
                    },
                    icon: const Icon(Icons.arrow_forward_ios),
                  ),
                );
              }
              final model = snapshot.data!.docs[index].data();
              return _BookWidget(model: model);
            },
          );
        },
      ),
    );
  }
}

class _BookWidget extends StatelessWidget {
  final BookMd model;
  const _BookWidget({required this.model});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 8.w),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: SizedBox(
          width: 136.w,
          child: GestureDetector(
            onTap: () {
              context.goToWebView(model.url);
            },
            child: DecoratedBox(
              decoration: BoxDecoration(color: context.colorScheme.primary),
              child: model.imageUrl.isEmpty
                  ? Center(
                      child: Text(model.title,
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(color: Colors.white, fontSize: 24.sp)),
                    )
                  : CachedNetworkImage(
                      imageUrl: model.imageUrl,
                      fit: BoxFit.fitHeight,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) => Center(
                        child: Text(model.title,
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .copyWith(
                                    color: Colors.white, fontSize: 24.sp)),
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
