// lib/src/view/home/home_view_state.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:up_down/src/model/room.dart';

part 'home_view_state.freezed.dart';

// home_view_state.dart
@freezed
class HomeViewState with _$HomeViewState {
  factory HomeViewState({
    @Default([]) List<Room> popularRooms,
    Room? selectedRoom,
    @Default(false) bool isLoading,
    String? errorMessage,
  }) = _HomeViewState;

  factory HomeViewState.initial() => HomeViewState();
}



// // 방 정보를 나타내는 모델
// class Room {
//   final String personName; // 인물 이름
//   final String roomName; // 방 이름
//   final Timestamp roomStartDate; // 방 시작 날짜 (타임스탬프)
//   final Timestamp roomEndDate; // 방 종료 날짜 (타임스탬프)
//   final String imageUrl; // 인물 프로필 사진 URL

//   Room({
//     required this.personName,
//     required this.roomName,
//     required this.roomStartDate,
//     required this.roomEndDate,
//     required this.imageUrl,
//   });
// }

// // HomeView의 상태를 관리하는 State 클래스
// class HomeViewState {
//   final List<Room> popularRooms; // 인기 방 목록
//   final Room? selectedRoom; // 현재 선택된 방 정보 (없을 수 있음)

//   HomeViewState({
//     required this.popularRooms,
//     required this.selectedRoom,
//   });

//   // 초기 상태 설정 (기본적으로 방 목록은 비어 있음)
//   HomeViewState.initial()
//       : popularRooms = [
//           Room(
//             personName: '테스트',
//             roomName: '테스트논란',
//             roomStartDate: Timestamp.fromMillisecondsSinceEpoch(
//                 DateTime.parse('2024-01-01 00:00:00')
//                     .millisecondsSinceEpoch), // 타임스탬프 변환
//             roomEndDate: Timestamp.fromMillisecondsSinceEpoch(
//                 DateTime.parse('2024-12-31 00:00:00')
//                     .millisecondsSinceEpoch), // 타임스탬프 변환
//             imageUrl:
//                 'https://firebasestorage.googleapis.com/v0/b/up-down-app.appspot.com/o/default_profile.png?alt=media&token=67dbee77-5ac9-4000-87c2-8357d9a38c12', // 이미지 URL 추가
//           ),
//         ],
//         selectedRoom = null; // 선택된 방은 기본적으로 null
// }
