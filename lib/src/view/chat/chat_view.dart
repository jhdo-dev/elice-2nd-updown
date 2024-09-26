import 'package:flutter/material.dart';

class ChatView extends StatelessWidget {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          '채팅방', // ViewModel에서 roomId를 가져옴
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: 10,
              itemBuilder: (context, index) {
                return Align(
                  alignment: true
                      ? Alignment.centerRight // 내 메시지는 오른쪽
                      : Alignment.centerLeft, // 상대는 왼쪽
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    margin: const EdgeInsets.symmetric(
                      vertical: 5.0,
                      horizontal: 10.0,
                    ),
                    decoration: BoxDecoration(
                      color: true ? Colors.blue : Colors.grey,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Text(
                      'hi',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: '메시지 입력',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Send'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
