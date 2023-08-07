import 'dart:convert';
import 'dart:math';

import 'package:dependency_plugin/dependency_plugin.dart';
import 'package:efapp/main.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

import '../utils/global_functions.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final AndroidNotificationDetails androidPlatformChannelSpecifics =
      const AndroidNotificationDetails(
    'default_notification', 'Default Notifications',
    channelDescription: "Default Notification Channel",
    importance: Importance.high,
    //Importance.max is unused on Android
    priority: Priority.high,
  );

  final DarwinNotificationDetails iosSpecification =
      const DarwinNotificationDetails(
    subtitle: "Default Notification",
    threadIdentifier: "default_notification",
  );

  Future<void> init() async {
    try {
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/launcher_icon');
      const InitializationSettings initializationSettings =
          InitializationSettings(android: initializationSettingsAndroid);

      await notificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: onBgNotificationResponse,
        onDidReceiveBackgroundNotificationResponse: onBgNotificationResponse,
      );
      Logger.i("NotificationService init completed");
    } catch (e) {
      Logger.e(e.toString(), tag: "NotificationService init");
    }
  }

  Future<void> showNotification(
      {required String title,
      required String body,
      required String payload}) async {
    try {
      final NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iosSpecification,
      );
      await notificationsPlugin.show(
        Random().nextInt(1000),
        title,
        body,
        platformChannelSpecifics,
        payload: payload,
      );
      Logger.i("NotificationService showNotification completed");
    } catch (e) {
      Logger.e(e.toString(), tag: "NotificationService showNotification");
    }
  }

  Future scheduleNotification(
      {int id = 0,
      String? title,
      String? body,
      String? payLoad,
      required int seconds,
      required String timezone}) async {
    if (seconds < 1) return;
    Logger.i(
        "NotificationService scheduleNotification started, $seconds seconds from now");
    tz.initializeTimeZones();

    return notificationsPlugin
        .zonedSchedule(
            Random().nextInt(1000),
            title,
            body,
            tz.TZDateTime.now(tz.getLocation(timezone))
                .add(Duration(seconds: seconds)),
            NotificationDetails(
              android: androidPlatformChannelSpecifics,
              iOS: iosSpecification,
            ),
            androidAllowWhileIdle: true,
            payload: payLoad,
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime)
        .then((_) {
      Logger.i("NotificationService scheduleNotification completed");
    });
  }
}
