import 'package:flutter/material.dart';
import 'package:up_down/src/view/home/widgets/popular_room_card.dart';
import 'package:up_down/src/view/home/widgets/room_list.dart';
import 'package:go_router/go_router.dart';

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
          Container(
            color: Colors.white,
            child: SizedBox(
              height: 200, // 원하는 높이로 설정
              child: PageView(
                children: const [
                  PopularRoomCard(roomName: '인기 방 1'),
                  PopularRoomCard(roomName: '인기 방 2'),
                  PopularRoomCard(roomName: '인기 방 3'),
                ],
              ),
            ),
          ),
          // 방 리스트
          const Expanded(child: RoomListPage()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.go('/create-room'); // 방 생성 페이지로 이동
        },
        child: const Icon(Icons.add), // 플로팅 버튼에 + 아이콘
      ),
    );
  }
}
