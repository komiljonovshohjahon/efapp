import 'package:efapp/presentation/global_widgets/widgets.dart';
import 'package:efapp/presentation/pages/home_view/blogs_list_view.dart';
import 'package:efapp/presentation/pages/home_view/books_list_view.dart';
import 'package:efapp/presentation/pages/home_view/love_offering_widget.dart';
import 'package:efapp/presentation/pages/home_view/videos_list_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'invent_your_grave.dart';

class HomeView extends StatefulWidget {
  HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: EdgeInsets.symmetric(vertical: 16.h),
          sliver: const SliverAppBar(
            titleSpacing: 0,
            title: Text("Evans Francis"),
            centerTitle: true,
            floating: true,
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate(
            [
              // if (kDebugMode)
              //   ElevatedButton(
              //       onPressed: () async {
              //         final Email email = Email(
              //           body: 'Email body',
              //           subject: 'Email subject',
              //           recipients: ['komiljonovshohjaon@gmail.com'],
              //           cc: ['cc@example.com'],
              //           bcc: ['bcc@example.com'],
              //           isHTML: false,
              //         );
              //
              //         await FlutterEmailSender.send(email);
              //       },
              //       child: const Text("Test")),

              //Books list
              const BooksListView(),

              SizedBox(height: 32.h),

              //Blogs list
              const BlogsListView(),

              SizedBox(height: 32.h),

              //Latest Videos
              const VideosListView(),

              SizedBox(height: 32.h),

              //Invest Beyond your grave
              const InvestYourGrave(),

              // //Love offering
              // const LoveOfferingWidget(),

              SizedBox(height: 16.h),
            ],
          ),
        ),
      ],
    );
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
