// lib/src/repository/home_repository_impl.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:up_down/src/model/room.dart';
import 'package:up_down/src/repository/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final FirebaseFirestore _firestore;

  HomeRepositoryImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Stream<List<Room>> getPopularRooms() {
    return _firestore
        .collection('rooms')
        .orderBy('participantCount', descending: true)
        .limit(3)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Room.fromFirestore(doc)).toList());
  }

  @override
  Stream<List<Room>> getChatRooms() {
    return _firestore
        .collection('rooms')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Room.fromFirestore(doc)).toList());
  }

  @override
  Future<void> createRoom(String roomName, String personName,
      DateTime roomStartDate, DateTime roomEndDate, String imageUrl) async {
    final roomRef = _firestore.collection('rooms').doc();
    final roomId = roomRef.id;

    await roomRef.set({
      'roomId': roomId,
      'roomName': roomName,
      'personName': personName,
      'roomStartDate': Timestamp.fromDate(roomStartDate),
      'roomEndDate': Timestamp.fromDate(roomEndDate),
      'imageUrl': imageUrl,
      'participantCount': 0,
      'createdAt': Timestamp.now(),
    });

    // participants 서브 컬렉션에 참여자 추가 (예시)
    await roomRef.collection('participants').add({
      'userId': 'exampleUserId', // 실제 사용자 ID를 넣어야 함
      'joinedAt': Timestamp.now(),
    });

    // messages 서브 컬렉션에 메시지 추가 (예시)
    await roomRef.collection('messages').add({
      'userId': 'exampleUserId', // 실제 사용자 ID를 넣어야 함
      'message': 'Hello, world!',
      'sentAt': Timestamp.now(),
    });
  }

  @override
  Future<void> addParticipant(String roomId, String userId) async {
    DocumentReference roomRef = _firestore.collection('rooms').doc(roomId);

    await roomRef.collection('participants').doc(userId).set({
      'userId': userId,
      'joinedAt': Timestamp.now(),
    });

    await roomRef.update({
      'participantCount': FieldValue.increment(1),
    });
  }

  @override
  Future<void> removeParticipant(String roomId, String userId) async {
    DocumentReference roomRef = _firestore.collection('rooms').doc(roomId);

    await roomRef.collection('participants').doc(userId).delete();

    await roomRef.update({
      'participantCount': FieldValue.increment(-1),
    });
  }
}
