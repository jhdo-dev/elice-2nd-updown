import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'result_view_state.dart';

final resultViewModelProvider =
    StateNotifierProvider<ResultViewModel, ResultViewState>((ref) {
  return ResultViewModel();
});

class ResultViewModel extends StateNotifier<ResultViewState> {
  ResultViewModel() : super(const ResultViewState.loading()) {
    fetchResults();
  }

  Future<void> fetchResults() async {
    state = const ResultViewState.loading();
    try {
      // 실제로는 여기서 home_view와 chat_view의 데이터를 가져와야 합니다.
      await Future.delayed(const Duration(seconds: 1)); // 시뮬레이션을 위한 딜레이
      final results = [
        VoteResultItem(
          id: '1',
          title: '김호중 음주운전 처벌 찬성하십니까?',
          imageUrl: 'https://picsum.photos/200/300?random=1',
          forPercentage: 60.5,
          againstPercentage: 39.5,
          isWinner: true,
        ),
        VoteResultItem(
          id: '2',
          title: '곽튜브 논란 찬성하십니까?',
          imageUrl: 'https://picsum.photos/200/300?random=2',
          forPercentage: 45.2,
          againstPercentage: 54.8,
          isWinner: false,
          hasAudio: true,
        ),
        // 추가 결과 아이템...
      ];
      state = ResultViewState.success(results);
    } catch (e) {
      state = ResultViewState.error(e.toString());
    }
  }

  Future<void> refreshResults() async {
    await fetchResults();
  }
}
