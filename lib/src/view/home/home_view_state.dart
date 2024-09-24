import 'package:flutter_riverpod/flutter_riverpod.dart';

// HomeView의 상태를 관리하는 StateNotifier
class HomeViewState {
  final List<String> popularRooms; // 인기 방 목록
  final String selectedRoom; // 현재 선택된 방 이름

  HomeViewState({
    required this.popularRooms,
    required this.selectedRoom,
  });

  HomeViewState.initial()
      : popularRooms = ['인기 방 1', '인기 방 2', '인기 방 3'],
        selectedRoom = ''; // 초기 상태 설정
}

// 상태를 관리하는 Notifier
class HomeViewNotifier extends StateNotifier<HomeViewState> {
  HomeViewNotifier() : super(HomeViewState.initial());

  // 방 선택 로직
  void selectRoom(String roomName) {
    state = HomeViewState(
      popularRooms: state.popularRooms,
      selectedRoom: roomName,
    );
  }

  // 인기 방 목록을 업데이트하는 로직
  void updatePopularRooms(List<String> newRooms) {
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
