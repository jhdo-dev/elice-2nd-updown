import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:up_down/src/model/room.dart';
import 'package:up_down/src/repository/vote_repository.dart'; //^ 추가

import 'result_view_state.dart';

final resultViewModelProvider =
    StateNotifierProvider<ResultViewModel, ResultViewState>((ref) {
  return ResultViewModel();
});

class ResultViewModel extends StateNotifier<ResultViewState> {
  ResultViewModel() : super(const ResultViewState.loading()) {
    fetchResults();
  }

  final VoteRepository _voteRepository = VoteRepository(); //^ 추가

  Future<void> fetchResults() async {
    state = const ResultViewState.loading();
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('rooms')
          .orderBy('createdAt', descending: true)
          .get();

      final results = await Future.wait(snapshot.docs.map((doc) async {
        final data = doc.data();
        final roomId = doc.id;

        //^ 투표 데이터 가져오기
        final voteSnapshot = await FirebaseFirestore.instance
            .collection('rooms')
            .doc(roomId)
            .collection('vote')
            .doc(roomId)
            .get();

        final voteData = voteSnapshot.data() ?? {};

        DateTime roomStartDate;
        DateTime roomEndDate;

        if (data['roomStartDate'] is Timestamp) {
          roomStartDate = (data['roomStartDate'] as Timestamp).toDate();
        } else if (data['roomStartDate'] is String) {
          roomStartDate = DateTime.parse(data['roomStartDate']);
        } else {
          roomStartDate = DateTime.now();
        }

        if (data['roomEndDate'] is Timestamp) {
          roomEndDate = (data['roomEndDate'] as Timestamp).toDate();
        } else if (data['roomEndDate'] is String) {
          roomEndDate = DateTime.parse(data['roomEndDate']);
        } else {
          roomEndDate = DateTime.now();
        }

        //^ 수정된 부분: 투표 데이터 사용
        final guiltyCount = voteData['guiltyCount'] as int? ?? 0;
        final notGuiltyCount = voteData['notGuiltyCount'] as int? ?? 0;
        final participants = voteData['participants'] as List<dynamic>? ?? [];

        final totalVotes = guiltyCount + notGuiltyCount;
        final forPercentage =
            totalVotes > 0 ? (guiltyCount / totalVotes) * 100 : 0.0;
        final againstPercentage =
            totalVotes > 0 ? (notGuiltyCount / totalVotes) * 100 : 0.0;

        return VoteResultItem(
          id: doc.id,
          title: data['roomName'] ?? '',
          imageUrl: data['imageUrl'] ?? '',
          forPercentage: forPercentage,
          againstPercentage: againstPercentage,
          isWinner: guiltyCount > notGuiltyCount,
          participantCount: participants.length,
          roomStartDate: roomStartDate,
          roomEndDate: roomEndDate,
        );
      }));

      state = ResultViewState.success(results);
    } catch (e) {
      state = ResultViewState.error(e.toString());
    }
  }

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
      print('Error updating vote result: $e');
    }
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
            final isWinner = guiltyCount > notGuiltyCount;

            updateVoteResultInFirestore(
              roomId: roomId,
              forPercentage: forPercentage,
              againstPercentage: againstPercentage,
              isWinner: isWinner,
            );

            return item.copyWith(
              forPercentage: forPercentage,
              againstPercentage: againstPercentage,
              isWinner: isWinner,
            );
          }
          return item;
        }).toList();

        state = ResultViewState.success(updatedResults);
      },
    );
  }

  Future<void> refreshResults() async {
    await fetchResults();
  }

  Future<void> addNewRoom(Room room) async {
    final roomRef =
        FirebaseFirestore.instance.collection('rooms').doc(room.roomId);
    await roomRef.set({
      'roomId': room.roomId,
      'roomName': room.roomName,
      'imageUrl': room.imageUrl,
      'participantCount': room.participantCount,
      'roomStartDate': room.roomStartDate,
      'roomEndDate': room.roomEndDate,
      'forPercentage': 0,
      'againstPercentage': 0,
      'isWinner': false,
    });

    await fetchResults();
  }
}
