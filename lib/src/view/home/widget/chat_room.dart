import 'package:flutter/material.dart';

class ChatRoom extends StatelessWidget {
  final String personName;
  final String roomName;
  final String roomStartDate;
  final String roomEndDate;

  const ChatRoom({
    super.key,
    required this.personName,
    required this.roomName,
    required this.roomStartDate,
    required this.roomEndDate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14.0),
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 14.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            children: [
              SizedBox(
                width: 70,
                height: 70,
                child: CircleAvatar(
                  backgroundColor: Colors.grey[300], // 아이콘 배경색
                  child: const Icon(
                    Icons.person, // 기본 아이콘
                    size: 30, // 아이콘 크기
                    color: Colors.white, // 아이콘 색상
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 14.0),
          Container(
            width: 1, // 선의 두께
            height: 75, // 선의 높이
            color: Colors.deepPurple, // 선의 색상
          ),
          const SizedBox(width: 14.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  personName,
                  style: const TextStyle(
                    fontSize: 18.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  roomName,
                  style: const TextStyle(
                    fontSize: 16.0,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 5.0),
                Text(
                  '시작: $roomStartDate',
                  style: const TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  '종료: $roomStartDate',
                  style: const TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    // fixedSize: const Size(60, 40),
                    ),
                onPressed: () {},
                child: const Text(
                  '입장',
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
