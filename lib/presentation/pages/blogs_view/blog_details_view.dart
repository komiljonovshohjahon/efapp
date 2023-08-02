import 'package:dependency_plugin/dependency_plugin.dart';
import 'package:efapp/presentation/global_widgets/widgets.dart';
import 'package:efapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BlogDetailsView extends StatelessWidget {
  final BlogMd blog;
  BlogDetailsView({Key? key, required this.blog}) : super(key: key);

  late final Widget html = Html(data: blog.description);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(12.w),
      child: Column(
        children: [
          //large image with some radius
          SizedBox(
            width: double.infinity,
            height: 220.h,
            child: Hero(
              tag: blog.id,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image:
                          DefaultCachedFirebaseImageProvider(blog.imagePath)),
                ),
              ),
            ),
          ),
          SizedBox(height: 12.h),

          //title
          Text(blog.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  decoration: TextDecoration.underline,
                  decorationColor: context.colorScheme.primary.withOpacity(.3),
                  decorationThickness: 3,
                  shadows: [
                    const Shadow(
                      color: Colors.black12,
                      blurRadius: 2,
                      offset: Offset(2, 2),
                    )
                  ])),

          SizedBox(height: 16.h),
          //date text inside 2 divider with primary color
          Divider(color: context.colorScheme.primary),
          SpacedRow(
            horizontalSpace: 8.w,
            children: [
              Icon(Icons.date_range,
                  color: context.colorScheme.primary, size: 20.r),
              Text(
                DateTime.tryParse(blog.createdAt)?.toDateWithSlash ?? "N/A",
                style: TextStyle(
                  color: context.colorScheme.primary,
                ),
              )
            ],
          ),
          Divider(color: context.colorScheme.primary),
          html,
        ],
      ),
    );
  }
}
