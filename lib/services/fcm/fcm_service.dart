import 'package:firebase_analytics/firebase_analytics.dart'; //^
import 'package:firebase_messaging/firebase_messaging.dart';

class FCMService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance; //^

  Future<void> initialize() async {
    String? token = await _firebaseMessaging.getToken();
    print("FCM Token: $token");

    _firebaseMessaging.onTokenRefresh.listen((newToken) {
      print("New FCM Token: $newToken");
      _sendTokenToServer(newToken);
    });

    _sendTokenToServer(token);

    // 메시지 핸들러 설정
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      //^
      print("Foreground message received: ${message.notification?.title}");
      _logMessageReceived(message);
    });
  }

  void _sendTokenToServer(String? token) {
    // TODO: 실제 서버 API를 호출하여 토큰 저장
    print("Sending token to server: $token");
  }

  Future<void> requestPermissions() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    print('User granted permission: ${settings.authorizationStatus}');
  }

  void _logMessageReceived(RemoteMessage message) {
    _analytics.logEvent(
      name: 'fcm_message_received',
      parameters: {
        'message_id': message.messageId ?? 'unknown', //^
        'title': message.notification?.title ?? 'No Title', //^
        'body': message.notification?.body ?? 'No Body', //^
      },
    );
  }
}
