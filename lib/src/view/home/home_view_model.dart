import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeViewModel {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Firestore에서 채팅방 목록 가져오기
  Future<List<Map<String, dynamic>>> fetchChatRooms() async {
    final snapshot = await _firestore.collection('rooms').get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  // Firestore에 새로운 채팅방 추가
  Future<void> createRoom(String roomName) async {
    await _firestore.collection('rooms').add({
      'roomName': roomName,
      'createdAt': Timestamp.now(),
    });
  }
}

// HomeViewModel Provider
final homeViewModelProvider = Provider<HomeViewModel>((ref) {
  return HomeViewModel();
});
