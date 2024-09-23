import 'package:flutter/material.dart';
import 'package:up_down/src/view/home/widget/chat_room.dart';

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
        roomStartDate: '2024-08-01 09:24',
        roomEndDate: '2024-08-24 18:48'),
    const ChatRoom(
        personName: '유아인',
        roomName: '약물 사용 의혹 및 수사 진행',
        roomStartDate: '2024-09-12 12:30',
        roomEndDate: '2024-09-30 18:00'),
    const ChatRoom(
        personName: '김선호',
        roomName: '사생활 논란과 복귀 여부',
        roomStartDate: '2024-09-01 10:00',
        roomEndDate: '2024-09-20 16:45'),
    const ChatRoom(
        personName: '서예지',
        roomName: '가스라이팅 논란 재조명',
        roomStartDate: '2024-08-15 13:00',
        roomEndDate: '2024-09-10 18:30'),
    const ChatRoom(
        personName: '홍상수',
        roomName: '불륜 논란과 영화계 복귀',
        roomStartDate: '2024-08-25 14:00',
        roomEndDate: '2024-09-15 19:00'),
    const ChatRoom(
        personName: '박유천',
        roomName: '성폭행 및 마약 사건 재조명',
        roomStartDate: '2024-09-05 15:30',
        roomEndDate: '2024-09-25 20:30'),
    const ChatRoom(
        personName: '정준영',
        roomName: '불법 촬영 및 집단 성범죄 논란',
        roomStartDate: '2024-09-10 11:00',
        roomEndDate: '2024-09-30 17:30'),
    const ChatRoom(
        personName: '승리',
        roomName: '버닝썬 사건과 출소 후 복귀 논란',
        roomStartDate: '2024-09-18 14:00',
        roomEndDate: '2024-10-05 19:00'),
    const ChatRoom(
        personName: '황하나',
        roomName: '마약 재범과 구속 논란',
        roomStartDate: '2024-08-20 16:00',
        roomEndDate: '2024-09-10 18:30'),
    const ChatRoom(
        personName: '조국',
        roomName: '조국 사태와 법정 공방',
        roomStartDate: '2024-09-22 10:30',
        roomEndDate: '2024-10-01 15:00'),
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
