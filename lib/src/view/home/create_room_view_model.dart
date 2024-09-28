// lib/src/view/home/create_room_view_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:up_down/src/provider/home_repository_provider.dart';
import 'package:up_down/src/view/home/create_room_view_state.dart';

part 'create_room_view_model.g.dart';

@Riverpod(keepAlive: true)
class CreateRoomViewModel extends _$CreateRoomViewModel {
  late final FirebaseFirestore _firestore;

  @override
  CreateRoomViewState build() {
    _firestore = ref.watch(firebaseFirestoreProvider);

    // 초기 상태 설정
    return CreateRoomViewState();
  }

  void setRoomStartDate(DateTime date) {
    state = state.copyWith(roomStartDate: date);
  }

  void setRoomEndDate(DateTime date) {
    state = state.copyWith(roomEndDate: date);
  }

  Future<void> createRoom(String personName, String roomName) async {
    final roomRef = _firestore.collection('rooms').doc();

    // Firestore에 방 정보 저장
    await roomRef.set({
      'roomId': roomRef.id,
      'personName': personName,
      'roomName': roomName,
      'roomStartDate': Timestamp.fromDate(state.roomStartDate!),
      'roomEndDate': Timestamp.fromDate(state.roomEndDate!),
      'imageUrl':
          'https://firebasestorage.googleapis.com/v0/b/up-down-app.appspot.com/o/default_profile.png?alt=media&token=67dbee77-5ac9-4000-87c2-8357d9a38c12', // 기본 이미지 URL
      'participantCount': 0, // 참가자 수 초기화
      'createdAt': Timestamp.now(),
    });
    // 방 생성 후 result_view 갱신 (결과 목록 다시 불러오기)
    //
    // 상태 초기화
    state = CreateRoomViewState();
  }
}
