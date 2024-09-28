import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:up_down/services/fcm/fcm_service.dart';
import 'package:up_down/services/fcm/push_notification_service.dart';
import 'package:up_down/util/router/route_path.dart';

import 'firebase_options.dart';

//백글라운드 메시지 등록
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  // FCM 서비스 초기화
  final fcmService = FCMService();
  await fcmService.initialize();

  // 푸시 알림 서비스 초기화
  final pushNotificationService = PushNotificationService();
  await pushNotificationService.initialize();

  // 알림 권한 요청
  await requestNotificationPermissions(fcmService); //^

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

//알림 권한 요청 함수
Future<void> requestNotificationPermissions(FCMService fcmService) async {
  //^
  await fcmService.requestPermissions(); //^
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routeProvider);

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
