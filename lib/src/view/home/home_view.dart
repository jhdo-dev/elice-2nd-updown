import 'package:flutter/material.dart';
import 'package:up_down/src/view/home/widget/room_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: const HomeView(), // HomeView 호출
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.deepPurpleAccent,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
          BottomNavigationBarItem(
              icon: Icon(Icons.assessment), label: 'Result'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'MyPage'),
        ],
      ),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
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
