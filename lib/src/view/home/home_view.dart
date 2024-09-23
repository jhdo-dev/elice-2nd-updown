import 'package:flutter/material.dart';
import 'package:up_down/src/view/home/widget/room_list.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'), // 타이틀 설정
      ),
      body: Column(
        children: [
          // 인기 방 스와이프 가능한 섹션
          SizedBox(
            height: 150, // 원하는 높이로 설정
            child: PageView(
              children: [
                _buildPopularRoomCard('인기 방 1'),
                _buildPopularRoomCard('인기 방 2'),
                _buildPopularRoomCard('인기 방 3'),
              ],
            ),
          ),
          // 방 리스트
          const Expanded(child: RoomListPage()),
        ],
      ),
    );
  }

  Widget _buildPopularRoomCard(String roomName) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Center(
        child: Text(
          roomName,
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
