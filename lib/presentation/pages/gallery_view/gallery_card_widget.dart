import 'package:dependency_plugin/dependency_plugin.dart';
import 'package:efapp/presentation/global_widgets/default_firebase_image_provider.dart';
import 'package:efapp/utils/global_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GalleryCardWidget extends StatelessWidget {
  final GalleryMd model;
  const GalleryCardWidget({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //todo:
      },
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8.r)),
          image: DecorationImage(
            fit: BoxFit.contain,
            image: DefaultCachedFirebaseImageProvider(model.image),
          ),
          border: Border.all(
              color: context.colorScheme.primary,
              width: 2.w,
              strokeAlign: BorderSide.strokeAlignOutside),
        ),
        child: Align(
          heightFactor: 1.5,
          alignment: Alignment.bottomCenter,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(8.r),
                bottomRight: Radius.circular(8.r),
              ),
            ),
            child: Text(
              model.title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: context.textTheme.labelSmall!.copyWith(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
