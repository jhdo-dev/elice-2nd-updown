import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';

class CreateRoomView extends StatefulWidget {
  const CreateRoomView({super.key});

  @override
  _CreateRoomViewState createState() => _CreateRoomViewState();
}

class _CreateRoomViewState extends State<CreateRoomView> {
  final TextEditingController personNameController = TextEditingController();
  final TextEditingController roomNameController = TextEditingController();
  DateTime? roomStartDate; // 방 시작 날짜
  DateTime? roomEndDate; // 방 종료 날짜

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('방 생성'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: personNameController,
              decoration: const InputDecoration(labelText: '인물 이름'),
            ),
            TextField(
              controller: roomNameController,
              decoration: const InputDecoration(labelText: '방 이름'),
            ),
            // 방 시작 날짜 선택
            TextButton(
              onPressed: () async {
                roomStartDate = await selectDate(context); // 날짜 선택
                setState(() {}); // 상태 업데이트
              },
              child: Text(roomStartDate == null
                  ? '방 시작 날짜 선택'
                  : '방 시작 날짜: ${roomStartDate!.toLocal()}'), // 선택된 날짜 표시
            ),
            // 방 종료 날짜 선택
            TextButton(
              onPressed: () async {
                roomEndDate = await selectDate(context); // 날짜 선택
                setState(() {}); // 상태 업데이트
              },
              child: Text(roomEndDate == null
                  ? '방 종료 날짜 선택'
                  : '방 종료 날짜: ${roomEndDate!.toLocal()}'), // 선택된 날짜 표시
            ),
            ElevatedButton(
              onPressed: () async {
                if (personNameController.text.isNotEmpty &&
                    roomNameController.text.isNotEmpty &&
                    roomStartDate != null &&
                    roomEndDate != null) {
                  await createRoom(); // 방 생성
                  // 방 생성 후 홈으로 이동
                  context.go('/home'); // 여기 수정된 부분
                }
              },
              child: const Text('방 생성'),
            ),
          ],
        ),
      ),
    );
  }

  Future<DateTime?> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    return picked; // 선택된 날짜 반환
  }

  Future<void> createRoom() async {
    // Firestore에 방 정보 저장
    await FirebaseFirestore.instance.collection('rooms').add({
      'personName': personNameController.text,
      'roomName': roomNameController.text,
      'roomStartDate': Timestamp.fromMillisecondsSinceEpoch(
          roomStartDate!.millisecondsSinceEpoch), // 타임스탬프 변환
      'roomEndDate': Timestamp.fromMillisecondsSinceEpoch(
          roomEndDate!.millisecondsSinceEpoch), // 타임스탬프 변환
      'imageUrl': 'gs://up-down-app.appspot.com/곽튜브.jpeg', // 기본 이미지 URL
    });
    // Navigator.pop(context); // 제거된 부분
  }
}
