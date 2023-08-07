import 'dart:convert';

import 'package:cad_audio_service/ui/audio_store_wrapper.dart';
import 'package:dependency_plugin/dependency_plugin.dart';
import 'package:dependency_plugin/firebase_options.dart';
import 'package:efapp/manager/manager.dart';
import 'package:flutter/material.dart';
import 'package:efapp/app.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

@pragma('vm:entry-point')
void onBgNotificationResponse(NotificationResponse message) {
  try {
    final payload = jsonDecode(message.payload ?? "{}");
    final route = payload["route"];
    if (route != null) {
      DependencyManager.instance.navigation.router
          .go("${MCANavigation.home}/$route", extra: payload);
    }
  } catch (e) {
    print(e);
  }
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingHandler(RemoteMessage message) async {
  final payload = jsonEncode(message.data);

  String title = "Notification Received";

  if (message.data['title'] != null) {
    title = "New ${message.data['title']} Available";
  }

  NotificationService().showNotification(
    title: title,
    payload: payload,
    body: "Tap to view details",
  );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  ///Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final DependencyManager dependencyManager = DependencyManager();
  await initDependencies(dependencyManager);

  await NotificationService().init();

  ///Request notification permission
  await FirebaseMessaging.instance
      .requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  )
      .then((permission) async {
    Logger.d(permission.authorizationStatus.toString(),
        tag: "FirebaseMessagingDep init");
    switch (permission.authorizationStatus) {
      case AuthorizationStatus.authorized:

        ///If authorized, subscribe to topic
        await FirebaseMessaging.instance
            .subscribeToTopic("send-scheduled-notifications-evans-francis");
        Logger.d("Subscribed to topic", tag: "FirebaseMessagingDep init");
        break;
      default:
        break;
    }
  });

  final fcmToken = await FirebaseMessaging.instance.getToken();
  Logger.d(fcmToken, tag: "FirebaseMessagingDep init");

  ///Listen to background messages
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingHandler);

  EquatableConfig.stringify = true;

  runApp(const AudioStoreWrapper(child: RunnerApp()));
}

//initialize dependencies
Future<void> initDependencies(DependencyManager dependencyManager) async {
  await dependencyManager.init(nav: MCANavigation());
}
