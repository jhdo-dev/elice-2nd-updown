import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:up_down/service/fcm/fcm_token.dart';
import 'package:up_down/service/fcm/push_notification_service.dart';
import 'package:up_down/util/router/route_path.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // FCM 서비스 초기화
  final fcmService = FCMService();
  await fcmService.initialize();

  // 푸시 알림 서비스 초기화
  final pushNotificationService = PushNotificationService();
  await pushNotificationService.initialize();

  // 알림 권한 요청
  await requestNotificationPermissions();

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

//^ 알림 권한 요청 함수
Future<void> requestNotificationPermissions() async {
  // FCMService나 PushNotificationService 클래스 내에 이 메서드를 구현하고 여기서 호출하는 것이 좋습니다.
  // 예: await FCMService.requestPermissions();
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
