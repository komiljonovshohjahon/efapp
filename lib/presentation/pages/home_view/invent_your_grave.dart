import 'package:efapp/presentation/global_widgets/widgets.dart';
import 'package:efapp/utils/global_constants.dart';
import 'package:efapp/utils/global_extensions.dart';
import 'package:efapp/utils/global_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InvestYourGrave extends StatelessWidget {
  const InvestYourGrave({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: SpacedColumn(
        crossAxisAlignment: CrossAxisAlignment.start,
        verticalSpace: 16.h,
        children: [
          Text("Invest Beyond Your Grave",
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(color: Colors.black)),
          const _InvestYourGraveContainer(),
        ],
      ),
    );
  }
}

class _InvestYourGraveContainer extends StatelessWidget {
  const _InvestYourGraveContainer();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        launchURL(Urls.investYourGraveUrl);
      },
      child: Container(
        width: double.infinity,
        height: 200.h,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 4,
                  offset: const Offset(0, 3))
            ],
            image: const DecorationImage(
                alignment: Alignment.centerRight,
                image: NetworkImage(
                    "https://investbeyondyourgrave.com/assets/images/image02.jpg?v=7cde060d"),
                fit: BoxFit.fill)),
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Align(
          alignment: Alignment.center,
          child: ElevatedButton(
              onPressed: () {
                context.goToWebView(Urls.investYourGraveUrl);
              },
              style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xFFf9ad34),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r))),
              child: const Text("Learn More")),
        ),
      ),
    );
  }
}
