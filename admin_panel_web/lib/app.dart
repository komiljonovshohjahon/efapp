import 'package:bot_toast/bot_toast.dart';
import 'package:dependency_plugin/dependency_plugin.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class RunnerApp extends StatefulWidget {
  const RunnerApp({super.key});

  @override
  State<RunnerApp> createState() => _RunnerAppState();
}

class _RunnerAppState extends State<RunnerApp> {
  final DependencyManager _dependencyManager = DependencyManager();

  // Restart the app
  void restart() {
    debugPrint("REBUIL APP from RUNNER");
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _dependencyManager.appDep.restart = restart;
  }

  final botToastBuilder = BotToastInit(); //1. call BotToastInit

  @override
  Widget build(BuildContext context) {
    print("rebuild app");
    final router = _dependencyManager.navigation.router;
    return MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: kDebugMode,
      // theme: FlexThemeData.light(
      //   scheme: FlexScheme.redWine,
      //   surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
      //   blendLevel: 7,
      //   subThemesData: const FlexSubThemesData(
      //     blendOnLevel: 10,
      //     blendOnColors: false,
      //     useTextTheme: true,
      //     useM2StyleDividerInM3: true,
      //     appBarBackgroundSchemeColor: SchemeColor.primary,
      //   ),
      //   visualDensity: FlexColorScheme.comfortablePlatformDensity,
      //   useMaterial3: true,
      //   swapLegacyOnMaterial3: true,
      //   fontFamily: GoogleFonts.notoSans().fontFamily,
      // ),
      // darkTheme: FlexThemeData.dark(
      //   scheme: FlexScheme.redWine,
      //   surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
      //   blendLevel: 13,
      //   subThemesData: const FlexSubThemesData(
      //     blendOnLevel: 20,
      //     useTextTheme: true,
      //     useM2StyleDividerInM3: true,
      //   ),
      //   visualDensity: FlexColorScheme.comfortablePlatformDensity,
      //   useMaterial3: true,
      //   swapLegacyOnMaterial3: true,
      //   fontFamily: GoogleFonts.notoSans().fontFamily,
      // ),
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
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            shadowColor: const Color(0xFFFAF8F1),
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
      // Use dark or light theme based on system setting.
      themeMode: ThemeMode.light,
      title: 'Evans Francis Admin',
      builder: (context, child) => botToastBuilder(
          context,
          MediaQuery(
              data:
                  MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
              child: child!)),
    );
  }
}
