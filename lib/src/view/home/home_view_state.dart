import 'package:flutter_riverpod/flutter_riverpod.dart';

// 방 정보를 나타내는 모델
class Room {
  final String personName; // 인물 이름
  final String roomName; // 방 이름
  final String roomStartDate; // 방 시작 날짜
  final String roomEndDate; // 방 종료 날짜
  final String imageUrl; // 인물 프로필 사진 URL

  Room({
    required this.personName,
    required this.roomName,
    required this.roomStartDate,
    required this.roomEndDate,
    required this.imageUrl,
  });
}

// HomeView의 상태를 관리하는 State 클래스
class HomeViewState {
  final List<Room> popularRooms; // 인기 방 목록
  final Room? selectedRoom; // 현재 선택된 방 정보 (없을 수 있음)

  HomeViewState({
    required this.popularRooms,
    required this.selectedRoom,
  });

  // 초기 상태 설정 (기본적으로 방 목록은 비어 있음)
  HomeViewState.initial()
      : popularRooms = [
          Room(
            personName: '곽튜브',
            roomName: '학폭 관련 인물 옹호 논란',
            roomStartDate: '2024-08-01 09:24',
            roomEndDate: '2024-08-24 18:48',
            imageUrl: 'https://example.com/image1.jpg',
          ),
          Room(
            personName: '유아인',
            roomName: '약물 사용 의혹 및 수사 진행',
            roomStartDate: '2024-09-12 12:30',
            roomEndDate: '2024-09-30 18:00',
            imageUrl: 'https://example.com/image2.jpg',
          ),
          Room(
            personName: '김선호',
            roomName: '사생활 논란과 복귀 여부',
            roomStartDate: '2024-09-01 10:00',
            roomEndDate: '2024-09-20 16:45',
            imageUrl: 'https://example.com/image3.jpg',
          ),
        ],
        selectedRoom = null;
}

// 상태를 관리하는 StateNotifier
class HomeViewNotifier extends StateNotifier<HomeViewState> {
  HomeViewNotifier() : super(HomeViewState.initial());

  // 방 선택 로직
  void selectRoom(Room room) {
    state = HomeViewState(
      popularRooms: state.popularRooms,
      selectedRoom: room,
    );
  }

  // 인기 방 목록을 업데이트하는 로직
  void updatePopularRooms(List<Room> newRooms) {
    state = HomeViewState(
      popularRooms: newRooms,
      selectedRoom: state.selectedRoom,
    );
  }
}

// Riverpod Provider 생성
final homeViewProvider =
    StateNotifierProvider<HomeViewNotifier, HomeViewState>((ref) {
  return HomeViewNotifier();
});
