import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'result_view_model.dart';
import 'result_view_state.dart';

//메시지
class ResultView extends ConsumerStatefulWidget {
  //^
  const ResultView({Key? key}) : super(key: key);

  @override
  _ResultViewState createState() => _ResultViewState(); //^
}

//^ 새로운 State 클래스
class _ResultViewState extends ConsumerState<ResultView> {
  //^
  //^ FCM 토큰 요청 및 로깅을 위한 메서드
  void setupPushNotifications() async {
    //^
    final fcm = FirebaseMessaging.instance;
    // Push Notification 권한 요구 - 반드시 Token을 얻기 전에 실시해야 함
    await fcm.requestPermission();

    // Firebase Message 토큰 얻기
    final fcmToken = await fcm.getToken();
    print('FCM Token: $fcmToken'); // 토큰을 로그에 출력
  }

  @override
  void initState() {
    //^
    super.initState();
    // 화면을 열었을 때 한 번만 실행되도록 initState() 안에서 실시
    setupPushNotifications();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(resultViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('투표 결과'),
        backgroundColor: Colors.red,
      ),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (message) => Center(child: Text('Error: $message')),
        success: (results) => RefreshIndicator(
          onRefresh: () =>
              ref.read(resultViewModelProvider.notifier).refreshResults(),
          child: ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) =>
                VoteResultCard(item: results[index]),
          ),
        ),
      ),
    );
  }
}

class VoteResultCard extends StatelessWidget {
  final VoteResultItem item;

  const VoteResultCard({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildPercentageBar(
                        context, item.forPercentage, item.againstPercentage),
                    _buildWinLoseIndicator(item.isWinner),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPercentageBar(
      BuildContext context, double forPercentage, double againstPercentage) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('찬성: ${forPercentage.toStringAsFixed(1)}%'),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: forPercentage / 100,
            backgroundColor: Colors.red[100],
            valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
          ),
          const SizedBox(height: 8),
          Text('반대: ${againstPercentage.toStringAsFixed(1)}%'),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: againstPercentage / 100,
            backgroundColor: Colors.blue[100],
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
        ],
      ),
    );
  }

  Widget _buildWinLoseIndicator(bool isWinner) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isWinner ? Colors.red : Colors.blue,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isWinner ? '나락' : '구원',
        style:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}
