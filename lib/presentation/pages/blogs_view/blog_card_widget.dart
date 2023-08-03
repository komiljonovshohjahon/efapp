import 'package:dependency_plugin/dependency_plugin.dart';
import 'package:efapp/manager/manager.dart';
import 'package:efapp/presentation/global_widgets/widgets.dart';
import 'package:efapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BlogCardWidget extends StatelessWidget {
  final BlogMd blog;
  const BlogCardWidget({Key? key, required this.blog}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Card with white background, has image on the left, the rest is filled with column of title and date
    return GestureDetector(
      onTap: () {
        context.goToBlogDetails(blog);
      },
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
        child: Padding(
          padding: EdgeInsets.all(8.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //image
              SizedBox(
                width: 84.w,
                height: 84.h,
                child: Hero(
                  tag: blog.id,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: DefaultCachedFirebaseImageProvider(
                              blog.imagePath)),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              //title and date
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(blog.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleSmall),
                      SizedBox(height: 4.h),
                      Text(
                          DateTime.tryParse(blog.createdAt)?.toDateWithSlash ??
                              "N/A",
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium!
                              .copyWith(color: context.colorScheme.secondary)),
                    ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
