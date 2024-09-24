import 'package:flutter/material.dart';
import 'package:up_down/src/view/home/widgets/chat_room.dart';

class RoomListPage extends StatelessWidget {
  const RoomListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChatRoomListPage(),
    );
  }
}

class ChatRoomListPage extends StatelessWidget {
  // 예시로 채팅방 목록 데이터를 생성
  final List<ChatRoom> chatRooms = [
    const ChatRoom(
        personName: '곽튜브',
        roomName: '학폭 관련 인물 옹호 논란',
        roomStartDate: '08/01',
        roomEndDate: '08/24'),
    const ChatRoom(
        personName: '유아인',
        roomName: '약물 의혹 및 수사 진행',
        roomStartDate: '09/12',
        roomEndDate: '09/30'),
    const ChatRoom(
        personName: '김선호',
        roomName: '사생활 논란과 복귀 여부',
        roomStartDate: '09/01',
        roomEndDate: '09/20'),
    const ChatRoom(
        personName: '서예지',
        roomName: '가스라이팅 논란 재조명',
        roomStartDate: '08/15',
        roomEndDate: '09/10'),
    const ChatRoom(
        personName: '홍상수',
        roomName: '불륜 논란과 영화계 복귀',
        roomStartDate: '08/25',
        roomEndDate: '09/15'),
    const ChatRoom(
        personName: '박유천',
        roomName: '성폭행 및 마약 사건 재조명',
        roomStartDate: '09/05',
        roomEndDate: '09/25'),
    const ChatRoom(
        personName: '정준영',
        roomName: '불법 촬영 및 성범죄 논란',
        roomStartDate: '09/10',
        roomEndDate: '09/30'),
    const ChatRoom(
        personName: '승리',
        roomName: '버닝썬 사건과 복귀 논란',
        roomStartDate: '09/18',
        roomEndDate: '10/05'),
    const ChatRoom(
        personName: '황하나',
        roomName: '마약 재범과 구속 논란',
        roomStartDate: '08/20',
        roomEndDate: '09/10'),
    const ChatRoom(
        personName: '조국',
        roomName: '조국 사태와 법정 공방',
        roomStartDate: '09/22',
        roomEndDate: '10/01'),
  ];

  ChatRoomListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView.builder(
        itemCount: chatRooms.length,
        itemBuilder: (context, index) {
          return chatRooms[index];
        },
      ),
    );
  }
}
