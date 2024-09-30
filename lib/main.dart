import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:up_down/services/fcm/fcm_service.dart';
import 'package:up_down/util/router/route_path.dart';

import 'firebase_options.dart';

// 백그라운드 메시지 핸들러 정의
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  //&
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase 초기화
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Firebase Analytics 초기화
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  // 푸시 알림 서비스 초기화 (통합된 서비스)
  final pushNotificationService = PushNotificationService();
  await pushNotificationService.initialize(); // 푸시 알림 초기화 메서드 호출

  // 백그라운드 메시지 핸들러 등록
  FirebaseMessaging.onBackgroundMessage(
      _firebaseMessagingBackgroundHandler); //&

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routeProvider);

    // FCM 메시지 처리 로직 추가
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Received a message in the foreground!');
      if (message.notification != null) {
        print(
            'Message also contained a notification: ${message.notification!.title}, ${message.notification!.body}');
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('User tapped on a notification and opened the app.');
    });

    return MaterialApp.router(
      title: 'UP DOWN',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: router,
    );
  }
}
