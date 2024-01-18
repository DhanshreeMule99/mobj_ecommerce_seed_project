// notificationservice

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mobj_project/utils/cmsConfigue.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize() {
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: AndroidInitializationSettings("@mipmap/ic_launcher"),
          iOS:IOSInitializationSettings( requestAlertPermission: true,
            requestBadgePermission: true,
            requestSoundPermission: true,)
    );

    _notificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? nid) async {});
  }

  static void createAndDisplayNotification(RemoteMessage message) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      const NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          AppString.fcmChannelName,
          AppString.fcmChannelName,
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: IOSNotificationDetails()
      );

      await _notificationsPlugin.show(
        id,
        message.notification!.title,
        message.notification!.body,
        notificationDetails,
        payload: message.data['nid'],
      );
    } on Exception catch (e) {}
  }
}
