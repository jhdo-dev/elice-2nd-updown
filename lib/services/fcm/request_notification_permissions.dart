//푸시알림 권한 요청
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> requestNotificationPermissions() async {
  NotificationSettings settings =
      await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  print('User granted permission: ${settings.authorizationStatus}');
}
