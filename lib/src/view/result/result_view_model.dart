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

  // Firestore에서 데이터를 불러오는 로직
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

        // Firestore에서 저장된 투표 결과 불러오기
        return VoteResultItem(
          id: doc.id,
          title: data['roomName'] ?? '',
          imageUrl: data['imageUrl'] ?? '',
          forPercentage: (data['forPercentage'] as num?)?.toDouble() ?? 0.0,
          againstPercentage:
              (data['againstPercentage'] as num?)?.toDouble() ?? 0.0,
          isWinner: data['isWinner'] ?? false,
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

  // 투표 결과를 Firestore에 저장하는 함수
  Future<void> updateVoteResultInFirestore({
    required String roomId,
    required double forPercentage,
    required double againstPercentage,
    required bool isWinner,
  }) async {
    try {
      await FirebaseFirestore.instance.collection('rooms').doc(roomId).update({
        'forPercentage': forPercentage,
        'againstPercentage': againstPercentage,
        'isWinner': isWinner,
      });
    } catch (e) {
      // Firestore 업데이트 실패 시 처리
      print('Error updating vote result: $e');
    }
  }

  // 투표 결과 업데이트 로직
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
            final isWinner = guiltyCount > notGuiltyCount;

            // Firestore에 투표 결과 저장
            updateVoteResultInFirestore(
              roomId: roomId,
              forPercentage: forPercentage,
              againstPercentage: againstPercentage,
              isWinner: isWinner,
            );

            // 상태 업데이트
            return item.copyWith(
              forPercentage: forPercentage,
              againstPercentage: againstPercentage,
              isWinner: isWinner,
            );
          }
          return item;
        }).toList();

        // 상태에 업데이트된 결과 반영
        state = ResultViewState.success(updatedResults);
      },
    );
  }

  Future<void> refreshResults() async {
    await fetchResults();
  }

  // 새로운 방을 추가하는 로직
  Future<void> addNewRoom(Room room) async {
    // Firestore에 새로운 방 정보 저장 //^ 추가
    final roomRef =
        FirebaseFirestore.instance.collection('rooms').doc(room.roomId); //^ 추가
    await roomRef.set({
      'roomId': room.roomId, //^ 추가
      'roomName': room.roomName, //^ 추가
      'imageUrl': room.imageUrl, //^ 추가
      'participantCount': room.participantCount, //^ 추가
      'roomStartDate': room.roomStartDate, //^ 추가
      'roomEndDate': room.roomEndDate, //^ 추가
      'forPercentage': 0, // 초기값 //^ 추가
      'againstPercentage': 0, // 초기값 //^ 추가
      'isWinner': false, // 초기값 //^ 추가
    }); //^ 추가

    // Firestore에 저장 후 결과 목록 갱신
    await fetchResults(); //^ 추가
  }
}
