import 'package:firebase_messaging/firebase_messaging.dart';

//fcm 토큰 수신
class FCMService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initialize() async {
    // FCM 토큰 요청
    String? token = await _firebaseMessaging.getToken();
    print("FCM Token: $token");

    // 토큰 갱신 리스너
    _firebaseMessaging.onTokenRefresh.listen((newToken) {
      print("New FCM Token: $newToken");
      // TODO: 새 토큰을 서버에 전송
    });

    // TODO: 토큰을 서버에 전송
    _sendTokenToServer(token);
  }

  void _sendTokenToServer(String? token) {
    // TODO: 실제 서버 API를 호출하여 토큰 저장
    print("Sending token to server: $token");
  }
}
