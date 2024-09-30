import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:up_down/services/fcm/fcm_service.dart';
import 'package:up_down/util/router/route_path.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase 초기화
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Firebase Analytics 초기화 (필요한 경우)
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  // 푸시 알림 서비스 초기화
  final pushNotificationService = PushNotificationService();
  await pushNotificationService.initialize();

  // FCM 토큰 가져오기 및 저장
  String? fcmToken = await FirebaseMessaging.instance.getToken();
  if (fcmToken != null) {
    await pushNotificationService.updateFCMToken(fcmToken);
    print("FCM Token: $fcmToken");
  }

  // FCM 토큰 리프레시 리스너 설정
  FirebaseMessaging.instance.onTokenRefresh.listen((String token) {
    pushNotificationService.updateFCMToken(token);
    print("FCM Token refreshed: $token");
  });

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
