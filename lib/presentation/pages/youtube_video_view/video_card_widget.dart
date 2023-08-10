import 'package:dependency_plugin/dependency_plugin.dart';
import 'package:efapp/manager/manager.dart';
import 'package:efapp/presentation/global_widgets/widgets.dart';
import 'package:efapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_plus/share_plus.dart';
import 'package:youtube/youtube_thumbnail.dart';

class VideoCardWidget extends StatelessWidget {
  final YtVideoMd model;
  const VideoCardWidget({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Card with white background, has image on the left, the rest is filled with column of title and date
    return GestureDetector(
      onTap: () {
        context.openWithHeroAnimation(YtPopup(item: model));
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
                  tag: model.id,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                              YoutubeThumbnail(youtubeId: model.videoId).hd())),
                    ),
                    child: Center(
                      child: Container(
                        width: 20.r,
                        height: 20.r,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.r),
                          color: context.colorScheme.primary,
                        ),
                        child: Icon(
                          color: Colors.white,
                          size: 10.r,
                          Icons.play_arrow_sharp,
                        ),
                      ),
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
                      Text(model.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleSmall),
                      SizedBox(height: 4.h),
                      Row(
                        children: [
                          Text(
                              DateTime.tryParse(model.createdAt)?.timeago ??
                                  "N/A",
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium!
                                  .copyWith(
                                      color: context.colorScheme.secondary)),
                          const Spacer(),
                          IconButton(
                            padding: EdgeInsets.zero,
                            iconSize: 20.r,
                            onPressed: () {
                              Share.share(model.url);
                            },
                            icon: const Icon(Icons.share),
                          ),
                        ],
                      ),
                    ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
