// lib/src/view/home/home_view_model.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:up_down/src/view/home/home_view_state.dart';
import 'package:up_down/src/repository/home_repository.dart';
import 'package:up_down/src/provider/home_repository_provider.dart';

part 'home_view_model.g.dart';

@Riverpod(keepAlive: true)
class HomeViewModel extends _$HomeViewModel {
  late final HomeRepository _repository;

  @override
  HomeViewState build() {
    _repository = ref.watch(homeRepositoryProvider);

    // 초기 상태 설정
    state = HomeViewState.initial();

    // 필요한 초기화 로직 수행
    _initPopularRooms();

    return state;
  }

  void _initPopularRooms() {
    _repository.getPopularRooms().listen((rooms) {
      state = state.copyWith(popularRooms: rooms);
    });
  }

  // 기타 필요한 메서드 추가
}
