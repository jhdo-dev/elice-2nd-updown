import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PushNotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // 초기화 함수
  Future<void> initialize() async {
    // FCM 토큰 생성 및 로그 기록
    String? token = await _firebaseMessaging.getToken();
    print("FCM Token: $token");

    _firebaseMessaging.onTokenRefresh.listen((newToken) {
      print("New FCM Token: $newToken");
    });

    // 포그라운드 알림 수신 처리
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Foreground message received: ${message.notification?.title}");
      _logMessageReceived(message); // Firebase Analytics 로그
      _showNotification(message); // 로컬 알림 표시
    });

    // 백그라운드 메시지 처리 등록
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // 알림 클릭 시 이벤트 처리
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("Notification clicked: ${message.notification?.title}");
      // TODO: 알림 클릭 시 특정 화면으로 이동하는 코드 추가
    });

    // 모든 유저 토픽 구독
    await subscribeToAllUsersTopic();

    // 알림 초기화 설정
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // FCM 알림 수신 시 Firebase Analytics에 로그 기록
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

  // 모든 유저 토픽 구독
  Future<void> subscribeToAllUsersTopic() async {
    try {
      print('Attempting to subscribe to all_users topic');
      await _firebaseMessaging.subscribeToTopic('all_users');
      print('Successfully subscribed to all_users topic');
    } catch (e) {
      print('Error subscribing to all_users topic: $e');
    }
  }

  // 서버에서 푸시 알림을 전송 (Cloud Functions 호출)
  Future<void> sendNotificationToAllUsers(String title, String body) async {
    try {
      // title과 body를 함수가 실행될 때마다 콘솔에 출력
      print('Title: $title');
      print('Body: $body');

      // Firebase Functions 호출 준비
      print('Attempting to send notification to all users');
      final HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('sendNotificationToTopic');

      // Firebase Functions 호출
      final response = await callable.call({
        'title': title, // 전달된 title 값
        'body': body, // 전달된 body 값
        'topic': 'all_users', // 'all_users' 토픽으로 전송
      });

      // Firebase Functions 응답 출력
      print('Cloud Function response: ${response.data}');

      // 성공 여부 확인
      if (response.data['success'] == true) {
        print('Notification sent successfully to all users.');
      } else {
        print(
            'Failed to send notification to all users. Response: ${response.data}');
        throw Exception(
            'Failed to send notification: ${response.data['error']}');
      }
    } catch (e) {
      print('Error sending notification to all users: $e');

      // Firebase Functions에서 발생한 오류가 있는 경우 예외 처리
      if (e is FirebaseFunctionsException) {
        print('Firebase Functions Error Code: ${e.code}');
        print('Firebase Functions Error Message: ${e.message}');
        print('Firebase Functions Error Details: ${e.details}');
      }

      rethrow; // 오류를 상위로 전파하여 UI에서 처리할 수 있게 함
    }
  }

  // 로컬 알림 표시
  void _showNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'high_importance_channel', // 채널 ID
      'High Importance Notifications', // 채널 이름
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.show(
      0, // 알림 ID
      message.notification?.title,
      message.notification?.body,
      platformChannelSpecifics,
    );
  }
}

// 알림 권한 요청 함수
Future<void> requestNotificationPermissions() async {
  NotificationSettings settings =
      await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    sound: true,
    provisional: false,
    announcement: false,
    carPlay: false,
    criticalAlert: false,
  );

  print('User granted permission: ${settings.authorizationStatus}');
}

// 백그라운드 메시지 핸들러
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Background message received: ${message.notification?.title}");
  // 백그라운드 메시지 처리 로직 추가
}
