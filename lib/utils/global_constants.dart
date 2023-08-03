import 'package:flutter/foundation.dart';

class GlobalConstants {
  //Create a singleton
  static final GlobalConstants _instance = GlobalConstants.internal();
  GlobalConstants.internal();
  factory GlobalConstants() => _instance;

  //Add your global constants here
  static const String debugusername = kDebugMode ? "test123@gmail.com" : "";
  static const String debugpassword = kDebugMode ? "test123!" : "";
  static const String debugpin = kDebugMode ? "192d7b" : "";

  static bool enableLogger = kDebugMode;

  static bool enableDebugCodes = kDebugMode;
  static bool enableLoadingIndicator = kDebugMode;

  static const developerWebsiteUrl = "https://www.christianappdevelopers.com";
}

class Urls {
  static const booksUrl = "https://notionpress.com/author/evans_francis";
  static const investYourGraveUrl = "https://investbeyondyourgrave.com";
}
