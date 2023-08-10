import 'package:dependency_plugin/dependency_plugin.dart';
import 'package:efapp/presentation/global_widgets/widgets.dart';
import 'package:efapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_plus/share_plus.dart';
import 'package:youtube/youtube_thumbnail.dart';

class MainVideoWidget extends StatelessWidget {
  final YtVideoMd model;
  const MainVideoWidget({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.openWithHeroAnimation(YtPopup(item: model));
      },
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(model.title,
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
        Hero(
          tag: model.id,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                      YoutubeThumbnail(youtubeId: model.videoId).hq())),
            ),
            child: SizedBox(
              width: double.infinity,
              height: 180.h,
              child: Center(
                child: Container(
                  width: 60.r,
                  height: 60.r,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.r),
                    color: context.colorScheme.primary,
                  ),
                  child: Icon(
                    color: Colors.white,
                    size: 50.r,
                    Icons.play_arrow_sharp,
                  ),
                ),
              ),
            ),
          ),
        ),
        Row(
          children: [
            Text(DateTime.tryParse(model.createdAt)?.timeago ?? "N/A",
                style: Theme.of(context)
                    .textTheme
                    .labelMedium!
                    .copyWith(color: context.colorScheme.primary)),
            const Spacer(),
            //share button
            IconButton(
              iconSize: 20.r,
              onPressed: () {
                Share.share(model.url);
              },
              icon: const Icon(Icons.share),
            ),
          ],
        ),
      ]),
    );
  }
}
