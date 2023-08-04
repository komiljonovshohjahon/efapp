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
}

class Urls {
  static const booksUrl = "https://notionpress.com/author/evans_francis";
  static const investYourGraveUrl = "https://investbeyondyourgrave.com";
  static const evansPaypalUrl = "https://www.paypal.com/paypalme/evansfrancis";
  static const developerWebsiteUrl = "https://www.christianappdevelopers.com";
  static const evansEmail = "evensfrancis333@oksbi";
  static const evansPaytmNumber = "9960877313";
  static const alansEmail = "alanalex138@gmail.com";
  static const sbiAccountName = "Evans Francis Albert";
  static const sbiAccountNumber = "32783806272";
  static const sbiAccountBank = "State Bank of India";
  static const sbiAccountIFSC = "SBIN0014726";
  static const sbiAccountBranch = "Jaripatka";
}
