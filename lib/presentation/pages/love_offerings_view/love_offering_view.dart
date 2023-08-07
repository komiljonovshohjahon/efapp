import 'package:bot_toast/bot_toast.dart';
import 'package:dependency_plugin/dependency_plugin.dart';
import 'package:efapp/presentation/global_widgets/spaced_row.dart';
import 'package:efapp/presentation/global_widgets/widgets.dart';
import 'package:efapp/utils/global_constants.dart';
import 'package:efapp/utils/global_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LoveOfferingView extends StatelessWidget {
  const LoveOfferingView({Key? key}) : super(key: key);

  final String desc =
      "God will richly bless the people who take of his servants (LK. 6:38). Put first and he will add to your life daily what you need (Matt.6 : 35).";

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
      child: Column(
        children: [
          //Image
          Container(
            alignment: Alignment.center,
            // width: 400.82.w,
            height: 339.35.h,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  left: 0,
                  top: 20.65.h,
                  child: Transform(
                    transform: Matrix4.identity()
                      ..translate(0.0, 0.0)
                      ..rotateZ(-0.06.r),
                    child: Container(
                      width: 268.w,
                      height: 310.h,
                      decoration: ShapeDecoration(
                        gradient: LinearGradient(
                          begin: Alignment(0.47.w, -0.88.h),
                          end: const Alignment(-0.47, 0.88),
                          colors: const [Color(0xFFF8AE34), Color(0xFF8C6924)],
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10).r,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 46.99.w,
                  top: 3.38.h,
                  child: Transform(
                    transform: Matrix4.identity()
                      ..translate(0.0, 0.0)
                      ..rotateZ(0.04.r),
                    child: Container(
                      width: 268.w,
                      height: 310.h,
                      decoration: ShapeDecoration(
                        gradient: LinearGradient(
                          begin: Alignment(0.47.w, -0.88.h),
                          end: Alignment(-0.47.w, 0.88.h),
                          colors: const [Color(0xFF8C6924), Color(0xFF8C6924)],
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10).r,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 10.64.w,
                  top: 0,
                  child: Transform(
                    transform: Matrix4.identity()
                      ..translate(0.0, 0.0)
                      ..rotateZ(0.10.r),
                    child: Container(
                      width: 330.w,
                      height: 310.h,
                      decoration: ShapeDecoration(
                        image: const DecorationImage(
                          image:
                              AssetImage("assets/images/love_offering_img.png"),
                          fit: BoxFit.fill,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10).r,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          //Desc as title and primary color
          Text(
            desc,
            textAlign: TextAlign.center,
            style: context.textTheme.titleMedium!.copyWith(
              color: context.colorScheme.primary,
            ),
          ),
          SizedBox(height: 20.h),
          //Card with payment options
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
              borderRadius: BorderRadius.circular(10).r,
            ),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //title (Choose payment)
                Text(
                  "Choose payment",
                  style: context.textTheme.titleSmall!.copyWith(
                    color: context.colorScheme.primary,
                  ),
                ),
                SizedBox(height: 10.h),
                //4 options (PayPal, GPay, SBI, Paytm)
                buildContainer(context,
                    image: 'assets/logos/pp.png', title: 'PayPal'),
                SizedBox(height: 10.h),
                buildContainer(context,
                    image: 'assets/logos/gpay.png', title: 'GPay'),
                SizedBox(height: 10.h),
                buildContainer(context,
                    image: 'assets/logos/sbi.png', title: 'SBI'),
                SizedBox(height: 10.h),
                buildContainer(context,
                    image: 'assets/logos/paytm.png', title: 'Paytm'),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildContainer(BuildContext context,
      {required String title, required String image}) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return SimpleDialog(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'You can send offering\nvia $title',
                      style: TextStyle(
                        color: context.colorScheme.primary,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        context.pop();
                      },
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                children: [
                  if (title == "PayPal")
                    ListTile(
                      leading: Image.asset(
                        image,
                        width: 30.w,
                        height: 30.h,
                      ),
                      title: TextButton.icon(
                          onPressed: () {
                            context.goToWebView(Urls.evansPaypalUrl);
                            context.pop();
                          },
                          style: TextButton.styleFrom(
                            alignment: Alignment.centerLeft,
                          ),
                          icon: Icon(Icons.open_in_new_rounded, size: 20.w),
                          label: const Text('paypal/EvansFrancis')),
                      subtitle: TextButton(
                        child: const Text(Urls.alansEmail),
                        onPressed: () {
                          copy(Urls.alansEmail);
                        },
                      ),
                    ),
                  if (title == "GPay")
                    ListTile(
                      leading: Image.asset(
                        image,
                        width: 30.w,
                        height: 30.h,
                      ),
                      trailing: IconButton(
                        onPressed: () {
                          copy(Urls.evansEmail);
                        },
                        icon: const Icon(Icons.copy_outlined),
                      ),
                      title: const Text(Urls.evansEmail),
                    ),
                  if (title == "Paytm")
                    ListTile(
                      leading: Image.asset(
                        image,
                        width: 30.w,
                        height: 30.h,
                      ),
                      trailing: IconButton(
                        onPressed: () {
                          copy(Urls.evansPaytmNumber);
                        },
                        icon: const Icon(Icons.copy_outlined),
                      ),
                      title: const Text(Urls.evansPaytmNumber),
                    ),
                  if (title == "SBI")
                    SpacedColumn(
                      verticalSpace: 4.h,
                      children: [
                        ListTile(
                          leading: Icon(Icons.person,
                              color: context.colorScheme.primary),
                          title: Text(
                            "Account Holder Name",
                            style: context.textTheme.titleSmall,
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              copy(Urls.sbiAccountName);
                            },
                            icon: const Icon(Icons.copy_outlined),
                          ),
                          subtitle: const Text(Urls.sbiAccountName),
                        ),
                        //account number
                        ListTile(
                          leading: Icon(Icons.numbers,
                              color: context.colorScheme.primary),
                          title: Text(
                            "Account Number",
                            style: context.textTheme.titleSmall,
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              copy(Urls.sbiAccountNumber);
                            },
                            icon: const Icon(Icons.copy_outlined),
                          ),
                          subtitle: const Text(Urls.sbiAccountNumber),
                        ),
                        //bank
                        ListTile(
                          leading: Icon(Icons.account_balance,
                              color: context.colorScheme.primary),
                          title: Text(
                            "Bank",
                            style: context.textTheme.titleSmall,
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              copy(Urls.sbiAccountBank);
                            },
                            icon: const Icon(Icons.copy_outlined),
                          ),
                          subtitle: const Text(Urls.sbiAccountBank),
                        ),
                        //IFSC
                        ListTile(
                          leading: Icon(Icons.code,
                              color: context.colorScheme.primary),
                          title: Text(
                            "IFSC Code",
                            style: context.textTheme.titleSmall,
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              copy(Urls.sbiAccountIFSC);
                            },
                            icon: const Icon(Icons.copy_outlined),
                          ),
                          subtitle: const Text(Urls.sbiAccountIFSC),
                        ),
                        //branch
                        ListTile(
                          leading: Icon(Icons.location_on,
                              color: context.colorScheme.primary),
                          title: Text(
                            "Branch",
                            style: context.textTheme.titleSmall,
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              copy(Urls.sbiAccountBranch);
                            },
                            icon: const Icon(Icons.copy_outlined),
                          ),
                          subtitle: const Text(Urls.sbiAccountBranch),
                        ),
                      ],
                    )
                ]);
          },
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          border: Border.all(
            color: context.colorScheme.primary.withOpacity(0.2),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(10).r,
        ),
        child: SpacedRow(
          crossAxisAlignment: CrossAxisAlignment.center,
          horizontalSpace: 10.w,
          children: [
            Container(
                width: 40.w,
                height: 30.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10).r,
                ),
                child: Image.asset(image)),
            Text(title, style: context.textTheme.labelLarge),
          ],
        ),
      ),
    );
  }

  void copy(String value) {
    Clipboard.setData(ClipboardData(text: value)).then((value) {
      BotToast.showText(text: 'Copied to clipboard');
    });
  }
}
