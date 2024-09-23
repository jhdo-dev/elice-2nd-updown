import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'result_view_model.dart';
import 'result_view_state.dart';

class ResultView extends ConsumerWidget {
  const ResultView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
        color: isWinner ? Colors.green : Colors.red,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isWinner ? '승' : '패',
        style:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}
