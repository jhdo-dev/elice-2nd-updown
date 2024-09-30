// lib/src/view/home/create_room_view_model.dart
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart'; // 추가된 부분
import 'package:image_picker/image_picker.dart'; // 추가된 부분
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:up_down/src/provider/home_repository_provider.dart';
import 'package:up_down/src/view/home/create_room_view_state.dart';

part 'create_room_view_model.g.dart';

@Riverpod(keepAlive: true)
class CreateRoomViewModel extends _$CreateRoomViewModel {
  late final FirebaseFirestore _firestore;
  late final FirebaseStorage _storage; // FirebaseStorage 필드 추가

  @override
  CreateRoomViewState build() {
    _firestore = ref.watch(firebaseFirestoreProvider);
    _storage = FirebaseStorage.instance; // FirebaseStorage 인스턴스 초기화

    // 초기 상태 설정
    return CreateRoomViewState();
  }

  // 이미지를 선택하고 업로드하는 메서드 추가
  Future<void> pickAndUploadImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final String fileName = image.name;
      final Reference storageRef =
          _storage.ref().child('room_images/$fileName');

      try {
        // Firebase Storage에 이미지 업로드
        await storageRef.putFile(File(image.path));
        final String downloadUrl = await storageRef.getDownloadURL();

        // 상태에 imageUrl 저장
        state = state.copyWith(imageUrl: downloadUrl);
      } catch (e) {
        print("Error uploading image: $e");
      }
    }
  }

  void setRoomStartDate(DateTime date) {
    state = state.copyWith(roomStartDate: date);
  }

  void setRoomEndDate(DateTime date) {
    state = state.copyWith(roomEndDate: date);
  }

  Future<String> createRoom(String personName, String roomName) async {
    final roomRef = _firestore.collection('rooms').doc();

    // Firestore에 방 정보 저장
    await roomRef.set({
      'roomId': roomRef.id,
      'personName': personName,
      'roomName': roomName,
      'roomStartDate': Timestamp.fromDate(state.roomStartDate!),
      'roomEndDate': Timestamp.fromDate(state.roomEndDate!),
      'imageUrl': state.imageUrl ??
          'https://firebasestorage.googleapis.com/v0/b/up-down-app.appspot.com/o/default_profile.png?alt=media&token=67dbee77-5ac9-4000-87c2-8357d9a38c12', // 기본 이미지 URL
      'participantCount': 0, // 참가자 수 초기화
      'createdAt': Timestamp.now(),
    });

    // 상태 초기화
    state = CreateRoomViewState();

    // roomId 반환
    return roomRef.id;
  }
}
