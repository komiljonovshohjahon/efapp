import 'package:dependency_plugin/dependency_plugin.dart';
import 'package:efapp/manager/manager.dart';
import 'package:efapp/presentation/global_widgets/widgets.dart';
import 'package:efapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

final List<Map<String, dynamic>> drawerDestinations = [
  {
    "title": "Home",
    "icon": Icons.home,
    "route": MCANavigation.home,
  },
  //blogs
  {
    "title": "Blogs",
    "icon": Icons.article,
    "route": "${MCANavigation.home}${MCANavigation.blogs}",
  },
  //books
  {
    "title": "Books",
    "icon": Icons.book,
    "route": "/books",
  },
  //gallery
  {
    "title": "Gallery",
    "icon": Icons.photo_library,
    "route": "${MCANavigation.home}${MCANavigation.galleryAlbum}",
  },
  //videos
  {
    "title": "Videos",
    "icon": Icons.video_library,
    "route": "${MCANavigation.home}${MCANavigation.yt}",
  },
  //contactUs
  {
    "title": "Contact Us",
    "icon": Icons.contact_mail,
    "route": "${MCANavigation.home}${MCANavigation.contactUs}",
  },
  {
    "title": "Submit a Prayer Request",
    "icon": Icons.send,
    "route": "${MCANavigation.home}${MCANavigation.prayerRequest}",
  },
  //todo: audio
// {
//   "title": "Audio",
//   "icon": Icons.audiotrack,
//   "route": "/audio",
// },
];

class DefaultDrawer extends StatelessWidget {
  DefaultDrawer({super.key});

  final dependencies = DependencyManager.instance;

  @override
  Widget build(BuildContext context) {
    return Drawer(
        backgroundColor: context.colorScheme.primary,
        width: context.width * .8,
        child: SafeArea(
          child: SpacedColumn(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Menus
              ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 0),
                  children: [
                    //App title
                    Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        child: Text(
                          "Evans Francis",
                          style: context.textTheme.titleLarge!.copyWith(
                              color: context.colorScheme.onPrimary,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    for (final destination in drawerDestinations)
                      ListTile(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.w, vertical: 0),
                          visualDensity: VisualDensity.compact,
                          isThreeLine: false,
                          minVerticalPadding: 0,
                          minLeadingWidth: 0,
                          leading: Icon(
                            destination["icon"],
                            color: context.colorScheme.onPrimary,
                          ),
                          title: Text(
                            destination["title"],
                            softWrap: true,
                            maxLines: 2,
                          ),
                          onTap: () {
                            if (destination['route'] == "/books") {
                              try {
                                context.goToWebView(Urls.booksUrl);
                              } catch (e) {
                                context.showError(
                                    "Could not open books. Please try again later.");
                              }
                            } else {
                              context.go(destination['route']!);
                            }
                            //close drawer
                            Scaffold.of(context).closeDrawer();
                          },
                          titleTextStyle: context.textTheme.bodyMedium!
                              .copyWith(color: context.colorScheme.onPrimary)),
                  ]),

              //Additional info
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Divider(
                      color: context.colorScheme.onPrimary,
                      thickness: 1.w,
                      height: 1.h,
                      endIndent: 16.w,
                      indent: 16.w),
                  GestureDetector(
                    onTap: () {
                      context.goToWebView(Urls.developerWebsiteUrl);
                      Scaffold.of(context).closeDrawer();
                      return;
                      launchURL(Urls.developerWebsiteUrl).then((value) {
                        if (!value) {
                          context.showError(
                              "Could not open developer's website. Please try again later.");
                        }
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset('assets/images/developer_logo.png',
                              width: 80.w, height: 80.h),
                          SizedBox(
                            width: context.width * .3,
                            child: Text(
                              "Affordable Christian\nApp Developer's",
                              textAlign: TextAlign.center,
                              style: context.textTheme.labelMedium!.copyWith(
                                  color: context.colorScheme.onPrimary),
                            ),
                          ),
                          Icon(Icons.arrow_forward_ios_rounded,
                              size: 24.w, color: context.colorScheme.onPrimary)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
