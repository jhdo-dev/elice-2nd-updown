// lib/src/home/home_view_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:up_down/src/model/room.dart';
import 'package:up_down/src/view/home/home_view_state.dart';

class HomeViewModel extends StateNotifier<HomeViewState> {
  HomeViewModel() : super(HomeViewState.initial());

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Firestore에서 채팅방 목록 가져오기
  Future<List<Map<String, dynamic>>> fetchChatRooms() async {
    final snapshot = await _firestore.collection('rooms').get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  // Firestore에 새로운 채팅방 추가 (문서 ID 랜덤 생성)
  Future<void> createRoom(String roomName, String personName,
      String roomStartDate, String roomEndDate, String imageUrl) async {
    final roomRef = _firestore.collection('rooms').doc(); // 랜덤 문서 ID 생성
    final roomId = roomRef.id;

    await roomRef.set({
      'roomId': roomId, // 랜덤 생성된 roomId
      'roomName': roomName,
      'personName': personName,
      'roomStartDate': roomStartDate,
      'roomEndDate': roomEndDate,
      'imageUrl': imageUrl,
      'participantCount': 0, // 추가된 필드
      'createdAt': Timestamp.now(),
    });

    // 방 생성 후 participants 서브 컬렉션에 참여자 추가 (예시)
    await roomRef.collection('participants').add({
      'userId': 'exampleUserId', // 실제 사용자 ID를 넣어야 함
      'joinedAt': Timestamp.now(),
    });

    // 방 생성 후 messages 서브 컬렉션에 메시지 추가 (예시)
    await roomRef.collection('messages').add({
      'userId': 'exampleUserId', // 실제 사용자 ID를 넣어야 함
      'message': 'Hello, world!',
      'sentAt': Timestamp.now(),
    });
  }

  Future<void> addParticipant(String roomId, String userId) async {
    DocumentReference roomRef =
        FirebaseFirestore.instance.collection('rooms').doc(roomId);

    // participants 서브컬렉션에 참여자 추가
    await roomRef.collection('participants').doc(userId).set({
      'userId': userId,
      'joinedAt': Timestamp.now(),
    });

    // participantCount 증가
    await roomRef.update({
      'participantCount': FieldValue.increment(1),
    });
  }

  Future<void> removeParticipant(String roomId, String userId) async {
    DocumentReference roomRef =
        FirebaseFirestore.instance.collection('rooms').doc(roomId);

    // participants 서브컬렉션에서 참여자 제거
    await roomRef.collection('participants').doc(userId).delete();

    // participantCount 감소
    await roomRef.update({
      'participantCount': FieldValue.increment(-1),
    });
  }
}

final popularRoomsProvider = StreamProvider<List<Room>>((ref) {
  return FirebaseFirestore.instance
      .collection('rooms')
      .orderBy('participantCount', descending: true)
      .limit(3) // 상위 3개 방만 가져옴
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Room.fromFirestore(doc)).toList());
});
