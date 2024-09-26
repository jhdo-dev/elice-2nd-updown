import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:up_down/src/model/room.dart';

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
      final snapshot =
          await FirebaseFirestore.instance.collection('rooms').get();
      final results = snapshot.docs.map((doc) {
        final data = doc.data();

        // roomStartDate와 roomEndDate의 타입에 따라 처리
        DateTime roomStartDate;
        DateTime roomEndDate;

        // roomStartDate 처리
        if (data['roomStartDate'] is Timestamp) {
          roomStartDate = (data['roomStartDate'] as Timestamp).toDate();
        } else if (data['roomStartDate'] is String) {
          roomStartDate = DateTime.parse(data['roomStartDate']);
        } else {
          roomStartDate = DateTime.now(); // 기본값 설정
        }

        // roomEndDate 처리
        if (data['roomEndDate'] is Timestamp) {
          roomEndDate = (data['roomEndDate'] as Timestamp).toDate();
        } else if (data['roomEndDate'] is String) {
          roomEndDate = DateTime.parse(data['roomEndDate']);
        } else {
          roomEndDate = DateTime.now(); // 기본값 설정
        }

        return VoteResultItem(
          id: doc.id,
          title: data['roomName'] ?? '',
          imageUrl: data['imageUrl'] ?? '',
          forPercentage: 0, // 초기값, 필요에 따라 수정
          againstPercentage: 0, // 초기값, 필요에 따라 수정
          isWinner: false, // 초기값, 필요에 따라 수정
          participantCount: data['participantCount'] ?? 0,
          roomStartDate: roomStartDate,
          roomEndDate: roomEndDate,
        );
      }).toList();
      state = ResultViewState.success(results);
    } catch (e) {
      state = ResultViewState.error(e.toString());
    }
  }

  Future<void> refreshResults() async {
    await fetchResults();
  }

  void addNewRoom(Room room) {
    state.whenOrNull(
      success: (currentResults) {
        final newItem = VoteResultItem(
          id: room.roomId,
          title: room.roomName,
          imageUrl: room.imageUrl,
          forPercentage: 0,
          againstPercentage: 0,
          isWinner: false,
          participantCount: room.participantCount,
          roomStartDate: room.roomStartDate,
          roomEndDate: room.roomEndDate,
        );
        state = ResultViewState.success([...currentResults, newItem]);
      },
    );
  }

  void updateVoteResult({
    required String roomId,
    required int guiltyCount,
    required int notGuiltyCount,
  }) {
    state.whenOrNull(
      success: (currentResults) {
        final updatedResults = currentResults.map((item) {
          if (item.id == roomId) {
            final totalVotes = guiltyCount + notGuiltyCount;
            final forPercentage =
                totalVotes > 0 ? (guiltyCount / totalVotes) * 100 : 0.0;
            final againstPercentage =
                totalVotes > 0 ? (notGuiltyCount / totalVotes) * 100 : 0.0;
            return item.copyWith(
              forPercentage: forPercentage,
              againstPercentage: againstPercentage,
              isWinner: guiltyCount > notGuiltyCount,
            );
          }
          return item;
        }).toList();
        state = ResultViewState.success(updatedResults);
      },
    );
  }
}
