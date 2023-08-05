import 'package:dependency_plugin/dependencies/firestore_dep.dart';
import 'package:dependency_plugin/dependency_plugin.dart';
import 'package:efapp/manager/manager.dart';
import 'package:efapp/presentation/global_widgets/default_firebase_image_provider.dart';
import 'package:efapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MainBlogWidget extends StatelessWidget {
  final BlogMd blog;
  const MainBlogWidget({Key? key, required this.blog}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.goToBlogDetails(blog);
      },
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
        if (blog.imagePath.isNotEmpty)
          Hero(
            tag: blog.id,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: DefaultCachedFirebaseImageProvider(blog.imagePath)),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 180.h,
              ),
            ),
          ),
        Row(
          children: [
            Text(DateTime.tryParse(blog.createdAt)?.toDateWithSlash ?? "N/A",
                style: Theme.of(context)
                    .textTheme
                    .labelMedium!
                    .copyWith(color: context.colorScheme.primary)),
            const Spacer(),
            //share button
            IconButton(
              iconSize: 20.r,
              onPressed: () {
                //todo:
              },
              icon: const Icon(Icons.share),
            ),
          ],
        ),
      ]),
    );
  }
}
