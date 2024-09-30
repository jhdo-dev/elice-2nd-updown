import 'dart:io';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

class PushNotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  Future<void> initialize() async {
    try {
      await _requestAndroidPermissions();
      await _configureLocalNotifications();
      await _configureFCM();
      await _createNotificationChannel();
    } catch (e) {
      print('Error initializing push notification service: $e');
    }
  }

  Future<void> sendNotification(
      {required String title,
      required String body,
      required String pushToken,
      String screen = "/main"}) async {
    try {
      HttpsCallable callable =
          FirebaseFunctions.instanceFor(region: 'asia-northeast3')
              .httpsCallable('sendPushNotification');
      final result = await callable.call({
        'title': title,
        'body': body,
        'token': pushToken,
        'screen': screen,
      });
      print("success : ${result.data}");
    } catch (e) {
      print('Caught generic exception: $e');
    }
  }

  Future<void> _requestAndroidPermissions() async {
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
  }

  Future<void> _configureLocalNotifications() async {
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

  Future<void> _configureFCM() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission for notifications');

      FirebaseMessaging.onMessage.listen(_handleMessage);
      FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);
      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);
    } else {
      print('User declined or has not accepted permission for notifications');
    }
  }

  void _handleMessage(RemoteMessage message) {
    print('Received a message in the foreground!');
    if (message.notification != null) {
      _showNotification(
          message.notification!.title, message.notification!.body);
    }
  }

  void _handleMessageOpenedApp(RemoteMessage message) {
    print('Notification clicked and app opened');
    // 여기에 알림 클릭 시 수행할 작업을 추가하세요
  }

  Future<void> _createNotificationChannel() async {
    if (Platform.isAndroid) {
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'general_channel',
        'General Notifications',
        importance: Importance.max,
      );

      await _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
    }
  }

  Future<void> _showNotification(String? title, String? body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'general_channel',
      'General Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.show(
      0,
      title ?? '알림',
      body ?? '내용 없음',
      platformChannelSpecifics,
    );
  }

  Future<String?> getToken() async {
    try {
      return await _firebaseMessaging.getToken();
    } catch (e) {
      print('Error getting FCM token: $e');
      return null;
    }
  }

  Future<void> subscribeToTopic(String topic) async {
    try {
      await _firebaseMessaging.subscribeToTopic(topic);
      print('Subscribed to topic: $topic');
    } catch (e) {
      print('Error subscribing to topic: $e');
    }
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _firebaseMessaging.unsubscribeFromTopic(topic);
      print('Unsubscribed from topic: $topic');
    } catch (e) {
      print('Error unsubscribing from topic: $e');
    }
  }

  Future<void> createRoom(String roomId, String roomName) async {
    try {
      final token = await getToken();
      if (token == null) {
        throw Exception('FCM token is null');
      }

      final callable = _functions.httpsCallable('createRoom');
      final result = await callable.call({
        'roomId': roomId,
        'roomName': roomName,
        'token': token,
      });

      if (result.data['success'] == true) {
        print('Room created successfully: ${result.data['message']}');
      } else {
        throw Exception('Failed to create room: ${result.data['message']}');
      }
    } on FirebaseFunctionsException catch (e) {
      print('Failed to call function: ${e.message}');
      throw Exception('Failed to create room: ${e.message}');
    } catch (e) {
      print('Error creating room: $e');
      throw Exception('Error creating room: $e');
    }
  }
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
  // 여기에 백그라운드 메시지 처리 로직을 추가하세요
}
