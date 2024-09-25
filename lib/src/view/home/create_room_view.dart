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
        leading: IconButton(
          onPressed: () {
            context.go('/home');
          },
          icon: const Icon(Icons.arrow_back),
        ),
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
            const SizedBox(height: 20),
            // 방 시작 날짜 선택
            ElevatedButton(
              onPressed: () async {
                roomStartDate = await selectDate(context); // 날짜 선택
                setState(() {}); // 상태 업데이트
              },
              child: Text(roomStartDate == null
                  ? '방 시작 날짜 선택'
                  : '방 시작 날짜: ${roomStartDate!.toLocal()}'), // 선택된 날짜 표시
            ),
            // 방 종료 날짜 선택
            ElevatedButton(
              onPressed: () async {
                roomEndDate = await selectDate(context); // 날짜 선택
                setState(() {}); // 상태 업데이트
              },
              child: Text(roomEndDate == null
                  ? '방 종료 날짜 선택'
                  : '방 종료 날짜: ${roomEndDate!.toLocal()}'), // 선택된 날짜 표시
            ),
            const SizedBox(height: 20),
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
              child: const Text(
                '방 생성',
                style:
                    TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: Center(
                child: ElevatedButton(
                  onPressed: () async {
                    // Firestore에 방 생성
                    DocumentReference roomRef = FirebaseFirestore.instance
                        .collection('rooms')
                        .doc(); // 랜덤 roomId 생성

                    await roomRef.set({
                      'roomId': roomRef.id,
                      'personName': '테스트인물',
                      'roomName': '테스트 논란1',
                      'roomStartDate': Timestamp.now(),
                      'roomEndDate': Timestamp.fromDate(DateTime(2024, 9, 27)),
                      'imageUrl':
                          'https://firebasestorage.googleapis.com/v0/b/up-down-app.appspot.com/o/default_profile.png?alt=media&token=67dbee77-5ac9-4000-87c2-8357d9a38c12',
                    });

                    // participants 서브 컬렉션에 참여자 추가 (테스트용)
                    await roomRef.collection('participants').add({
                      'userId': 'testUserId', // 테스트용 사용자 ID
                      'joinedAt': Timestamp.now(),
                    });

                    // messages 서브 컬렉션에 메시지 추가 (테스트용)
                    await roomRef.collection('messages').add({
                      'userId': 'testUserId', // 테스트용 사용자 ID
                      'message': '테스트 메시지입니다.',
                      'sentAt': Timestamp.now(),
                    });

                    // 완료 알림
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('방 생성 및 서브 컬렉션 추가 완료!')),
                    );
                  },
                  child: const Text(
                    '방 생성 테스트',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),
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
    // roomId를 랜덤하게 생성
    final roomId = FirebaseFirestore.instance.collection('rooms').doc().id;

    // Firestore에 방 정보 저장
    await FirebaseFirestore.instance.collection('rooms').add({
      'roomId': roomId,
      'personName': personNameController.text,
      'roomName': roomNameController.text,
      'roomStartDate': Timestamp.fromMillisecondsSinceEpoch(
          roomStartDate!.millisecondsSinceEpoch), // 타임스탬프 변환
      'roomEndDate': Timestamp.fromMillisecondsSinceEpoch(
          roomEndDate!.millisecondsSinceEpoch), // 타임스탬프 변환
      'imageUrl':
          'https://firebasestorage.googleapis.com/v0/b/up-down-app.appspot.com/o/default_profile.png?alt=media&token=67dbee77-5ac9-4000-87c2-8357d9a38c12', // 기본 이미지 URL
    });
  }
}
