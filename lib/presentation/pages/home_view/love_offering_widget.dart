import 'package:efapp/presentation/global_widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoveOfferingWidget extends StatelessWidget {
  const LoveOfferingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: SpacedColumn(
        crossAxisAlignment: CrossAxisAlignment.start,
        verticalSpace: 16.h,
        children: [
          Text("Love Offering",
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(color: Colors.black)),
          const _LoveOfferingContainer(),
        ],
      ),
    );
  }
}

class _LoveOfferingContainer extends StatelessWidget {
  const _LoveOfferingContainer();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //todo:
      },
      child: Container(
        width: double.infinity,
        height: 200.h,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            color: Colors.white,
            image: const DecorationImage(
                image: AssetImage("assets/images/family_image.png"),
                fit: BoxFit.cover)),
      ),
    );
  }
}
