import 'dart:convert';
import 'dart:io';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:dependency_plugin/dependency_plugin.dart';
import 'package:efapp/manager/manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'main.dart';

class RunnerApp extends StatefulWidget {
  const RunnerApp({super.key});

  @override
  State<RunnerApp> createState() => _RunnerAppState();
}

class _RunnerAppState extends State<RunnerApp> {
  final DependencyManager _dependencyManager = DependencyManager();

  final botToastBuilder = BotToastInit();

  @override
  void initState() {
    super.initState();
    // FirebaseMessaging.onMessage.listen(firebaseMessagingHandler);
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
    //   if (!(!kIsWeb && Platform.isLinux)) {
    //     final pending = await NotificationService()
    //         .notificationsPlugin
    //         .getNotificationAppLaunchDetails();
    //     final bool didNotificationLaunchApp =
    //         pending?.didNotificationLaunchApp ?? false;
    //     final notificationResponse = pending?.notificationResponse;
    //     bool shouldMoveToRoute = false;
    //     if (didNotificationLaunchApp &&
    //         notificationResponse != null &&
    //         notificationResponse.payload != null &&
    //         notificationResponse.payload!.isNotEmpty) {
    //       shouldMoveToRoute = true;
    //     }
    //     if (shouldMoveToRoute) {
    //       onBgNotificationResponse(pending!.notificationResponse!);
    //     }
    //   }
    // });
  }

  //1. call BotToastInit

  @override
  Widget build(BuildContext context) {
    final router = _dependencyManager.navigation.router;
    return ScreenUtilInit(
      designSize: const Size(360, 720),
      builder: (context, child) => MaterialApp.router(
        routerConfig: router,
        debugShowCheckedModeBanner: kDebugMode,
        title: 'Evans Francis',
        theme: ThemeData(
          scaffoldBackgroundColor: const Color(0xFFFAF8F1),
          appBarTheme: const AppBarTheme(
            elevation: 0,
            backgroundColor: Color(0xFFFAF8F1),
            foregroundColor: Color(0xFF3A3A3A),
          ),
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF8C6924),
            secondary: Color(0xFF3A3A3A),
            tertiary: Color(0xFFB9BCBE),
            onBackground: Color(0xFF3A3A3A),
          ),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            elevation: 0,
            backgroundColor: Color(0xFFFAF8F1),
            selectedItemColor: Color(0xFF8C6924),
            unselectedItemColor: Color(0xFFB9BCBE),
          ),
          radioTheme: RadioThemeData(
            fillColor: MaterialStateProperty.resolveWith((states) {
              if (states.contains(MaterialState.selected)) {
                return const Color(0xFF8C6924);
              } else if (states.contains(MaterialState.disabled)) {
                return const Color(0xFFB9BCBE);
              }
              return const Color(0xFF8C6924);
            }),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              foregroundColor: const Color(0xFF8C6924),
              backgroundColor: const Color(0xFF8c6924).withOpacity(.2),
              elevation: 0,
              textStyle: GoogleFonts.outfitTextTheme().labelLarge!.copyWith(),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.r)),
              padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 20.w),
              shadowColor: const Color(0xFFFAF8F1),
              surfaceTintColor: const Color(0xFFFAF8F1),
            ),
          ),
          iconButtonTheme: IconButtonThemeData(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all(Color(0xFF8C6924)),
              overlayColor: MaterialStateProperty.all(Color(0xFFFAF8F1)),
            ),
          ),
          textTheme: GoogleFonts.outfitTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          MonthYearPickerLocalizations.delegate,
        ],
        builder: (context, child) => botToastBuilder(
          context,
          MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child!,
          ),
        ),
      ),
    );
  }
}
