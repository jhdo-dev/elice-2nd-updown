import 'package:cloud_functions/cloud_functions.dart'; // Firebase Functions 호출을 위한 패키지
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FCMService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  Future<void> initialize() async {
    // FCM 토큰을 가져오고 서버로 전송
    String? token = await _firebaseMessaging.getToken();
    print("FCM Token: $token");

    // 토큰이 갱신될 때 서버로 전송
    _firebaseMessaging.onTokenRefresh.listen((newToken) {
      print("New FCM Token: $newToken");
      _sendTokenToServer(newToken);
    });

    // 최초 FCM 토큰 서버 전송
    _sendTokenToServer(token);

    // Foreground 상태에서 메시지 수신 시 처리
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Foreground message received: ${message.notification?.title}");
      _logMessageReceived(message);
    });
  }

  // Firestore에 FCM 토큰 저장 (Firebase Functions 호출)
  Future<void> _sendTokenToServer(String? token) async {
    if (token == null) return;

    try {
      // Firebase Functions 호출
      final HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('saveToken');
      final response = await callable.call(<String, dynamic>{
        'token': token,
      });

      if (response.data['success']) {
        print('Token successfully sent to server.');
      } else {
        print('Failed to send token.');
      }
    } catch (e) {
      print('Error sending token: $e');
    }
  }

  // 푸시 알림 권한 요청
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

  // Firebase Analytics로 수신 메시지 로깅
  void _logMessageReceived(RemoteMessage message) {
    _analytics.logEvent(
      name: 'fcm_message_received',
      parameters: {
        'message_id': message.messageId ?? 'unknown',
        'title': message.notification?.title ?? 'No Title',
        'body': message.notification?.body ?? 'No Body',
      },
    );
  }

  // Firebase Functions로 알림 전송
  Future<void> sendNotification(String title, String body, String topic) async {
    try {
      print('Sending notification: $title, $body, $topic');
      final HttpsCallable callable = FirebaseFunctions.instance
          .httpsCallable('sendNotification'); // Cloud Function 호출
      final response = await callable.call({
        'title': title,
        'body': body,
        'topic': topic,
      });
      print('Notification response: ${response.data}');

      if (response.data['success']) {
        print('Notification sent successfully.');
      } else {
        print('Failed to send notification. Server response: ${response.data}');
      }
    } catch (e) {
      print('Error sending notification: $e');
    }
  }
}
