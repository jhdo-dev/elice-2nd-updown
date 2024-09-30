import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> initialize() async {
    try {
      await _requestPermissions();
      await _configureFCM();
    } catch (e) {
      print('Error initializing push notification service: $e');
    }
  }

  Future<void> updateFCMToken(String token) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).update({
          'fcmToken': token,
        });
        print('FCM token updated for user: ${user.uid}');
      } else {
        print('User not logged in, FCM token not updated');
      }
    } catch (e) {
      print('Error updating FCM token: $e');
    }
  }

  Future<void> sendNotification({
    required String title,
    required String body,
    required String pushToken,
  }) async {
    try {
      // 여기에 기존의 sendNotification 로직을 유지합니다.
    } catch (e) {
      print('Failed to send push notification: $e');
    }
  }

  Future<void> _requestPermissions() async {
    final settings = await _firebaseMessaging.requestPermission();
    if (settings.authorizationStatus != AuthorizationStatus.authorized) {
      print('User declined or has not accepted permission for notifications');
    }
  }

  Future<void> _configureFCM() async {
    // 여기에 기존의 FCM 설정 로직을 유지합니다.
  }

  Future<String?> getToken() async {
    try {
      return await _firebaseMessaging.getToken();
    } catch (e) {
      print('Error getting FCM token: $e');
      return null;
    }
  }
}
