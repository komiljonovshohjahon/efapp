import 'package:efapp/presentation/global_widgets/widgets.dart';
import 'package:efapp/presentation/pages/home_view/blogs_list_view.dart';
import 'package:efapp/presentation/pages/home_view/books_list_view.dart';
import 'package:efapp/presentation/pages/home_view/love_offering_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeView extends StatefulWidget {
  HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 32.h),
      child: SpacedColumn(
        crossAxisAlignment: CrossAxisAlignment.start,
        verticalSpace: 32.h,
        children: const [
          //Search Bar
          DefaultSearchBar(),

          //Books list
          BooksListView(),

          //Blogs list
          BlogsListView(),

          //Love offering
          LoveOfferingWidget(),
        ],
      ),
    );
  }
}
