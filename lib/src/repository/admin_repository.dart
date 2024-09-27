// lib/src/repository/admin_repository.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  AdminRepository({FirebaseFirestore? firestore, FirebaseAuth? auth})
      : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  /// 현재 사용자가 관리자 권한을 가지고 있는지 실시간으로 확인합니다.
  Stream<bool> isCurrentUserAdminStream() {
    final user = _auth.currentUser;
    if (user == null) return Stream.value(false);

    return _firestore.collection('users').doc(user.uid).snapshots().map((doc) {
      if (!doc.exists) return false;
      final data = doc.data();
      return data?['isAdmin'] == true;
    }).handleError((error) {
      print('Error fetching admin status stream: $error');
      return false;
    });
  }
}
