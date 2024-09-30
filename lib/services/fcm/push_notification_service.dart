// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
// class PushNotificationService {
//   final FirebaseMessaging _fcm = FirebaseMessaging.instance;
//   final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//
//   Future<void> initialize() async {
//     // 포그라운드 알림 수신 처리
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       print("Foreground message received: ${message.notification?.title}");
//       _showNotification(message);
//     });
//
//     // 백그라운드 메시지 처리 등록
//     FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//
//     // 알림 클릭 시 이벤트 처리
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       print("Notification clicked: ${message.notification?.title}");
//       // TODO: 알림 클릭 시 특정 화면으로 이동하는 코드 추가
//     });
//
//     // 알림 초기화 설정
//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('@mipmap/ic_launcher');
//     final DarwinInitializationSettings initializationSettingsIOS =
//         DarwinInitializationSettings();
//     final InitializationSettings initializationSettings =
//         InitializationSettings(
//       android: initializationSettingsAndroid,
//       iOS: initializationSettingsIOS,
//     );
//     await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
//   }
//
//   // 알림 표시
//   void _showNotification(RemoteMessage message) async {
//     const AndroidNotificationDetails androidPlatformChannelSpecifics =
//         AndroidNotificationDetails(
//       'high_importance_channel', // 채널 ID
//       'High Importance Notifications', // 채널 이름
//       importance: Importance.max,
//       priority: Priority.high,
//     );
//     const NotificationDetails platformChannelSpecifics =
//         NotificationDetails(android: androidPlatformChannelSpecifics);
//
//     await _flutterLocalNotificationsPlugin.show(
//       0, // 알림 ID
//       message.notification?.title,
//       message.notification?.body,
//       platformChannelSpecifics,
//     );
//   }
// }
//
// // 알림 권한 요청 함수 추가
// Future<void> requestNotificationPermissions() async {
//   NotificationSettings settings =
//       await FirebaseMessaging.instance.requestPermission(
//     alert: true,
//     badge: true,
//     sound: true,
//     provisional: false,
//     announcement: false,
//     carPlay: false,
//     criticalAlert: false,
//   );
//
//   print('User granted permission: ${settings.authorizationStatus}'); //^
// }
//
// // 백그라운드 메시지 핸들러
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   print("Background message received: ${message.notification?.title}");
//   // 백그라운드 메시지 처리 로직 추가
// }
