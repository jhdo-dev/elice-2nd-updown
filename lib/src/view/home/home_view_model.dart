import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Room 모델에 imageUrl 추가
class Room {
  final String personName; // 인물 이름
  final String roomName; // 방 이름
  final Timestamp roomStartDate; // 방 시작 날짜 (타임스탬프)
  final Timestamp roomEndDate; // 방 종료 날짜 (타임스탬프)
  final String imageUrl; // 인물 프로필 사진 URL

  Room({
    required this.personName,
    required this.roomName,
    required this.roomStartDate,
    required this.roomEndDate,
    required this.imageUrl,
  });
}

class HomeViewModel {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Firestore에서 채팅방 목록 가져오기
  Future<List<Room>> fetchChatRooms() async {
    final snapshot = await _firestore.collection('rooms').get();
    // Map에서 Room 객체로 변환
    return snapshot.docs.map((doc) {
      final data = doc.data();
      return Room(
        personName: data['personName'],
        roomName: data['roomName'],
        roomStartDate: data['roomStartDate'], // 변경된 부분
        roomEndDate: data['roomEndDate'], // 변경된 부분
        imageUrl: data['imageUrl'], // 추가된 부분
      );
    }).toList();
  }

  // Firestore에 새로운 채팅방 추가
  Future<void> createRoom(String roomName, String personName,
      Timestamp roomStartDate, Timestamp roomEndDate, String imageUrl) async {
    // 이미지 URL 추가
    await _firestore.collection('rooms').add({
      'roomName': roomName,
      'personName': personName,
      'roomStartDate': roomStartDate,
      'roomEndDate': roomEndDate,
      'imageUrl': imageUrl, // 추가된 부분
      'createdAt': Timestamp.now(),
    });
  }
}

// HomeViewModel Provider
final homeViewModelProvider = Provider<HomeViewModel>((ref) {
  return HomeViewModel();
});
