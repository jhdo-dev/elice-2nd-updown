// lib/src/view/home/create_room_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:up_down/services/fcm/fcm_service.dart';
import 'package:up_down/src/view/home/create_room_view_model.dart';

class CreateRoomView extends ConsumerStatefulWidget {
  const CreateRoomView({super.key});

  @override
  ConsumerState<CreateRoomView> createState() => _CreateRoomViewState();
}

class _CreateRoomViewState extends ConsumerState<CreateRoomView> {
  final TextEditingController personNameController = TextEditingController();
  final TextEditingController roomNameController = TextEditingController();

  // fcmService 인스턴스 추가
  final PushNotificationService fcmService = PushNotificationService();

  @override
  void dispose() {
    personNameController.dispose();
    roomNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(createRoomViewModelProvider.notifier);
    final state = ref.watch(createRoomViewModelProvider);

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
                final pickedDate = await selectDate(context);
                if (pickedDate != null) {
                  viewModel.setRoomStartDate(pickedDate);
                }
              },
              child: Text(state.roomStartDate == null
                  ? '방 시작 날짜 선택'
                  : '방 시작 날짜: ${state.roomStartDate!.toLocal().toString().substring(0, 10)}'),
            ),
            // 방 종료 날짜 선택
            ElevatedButton(
              onPressed: () async {
                final pickedDate = await selectDate(context);
                if (pickedDate != null) {
                  viewModel.setRoomEndDate(pickedDate);
                }
              },
              child: Text(state.roomEndDate == null
                  ? '방 종료 날짜 선택'
                  : '방 종료 날짜: ${state.roomEndDate!.toLocal().toString().substring(0, 10)}'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (personNameController.text.isNotEmpty &&
                    roomNameController.text.isNotEmpty &&
                    state.roomStartDate != null &&
                    state.roomEndDate != null) {
                  try {
                    await viewModel.createRoom(
                      personNameController.text,
                      roomNameController.text,
                    );

                    // // title이 비어있지 않도록 보장
                    // String title = roomNameController.text.isNotEmpty
                    //     ? '새로운 방 "${roomNameController.text}"이 생성되었습니다!'
                    //     : '새로운 방이 생성되었습니다!';
                    //
                    // String body =
                    //     '${personNameController.text}님이 새로운 방을 만들었습니다.';
                    //
                    // // 값 확인용 로그
                    // print('Sending notification - Title: $title, Body: $body');
                    //
                    // await fcmService.sendNotificationToAllUsers(title, body);
                    //
                    // // 입력 필드 초기화
                    // personNameController.clear();
                    // roomNameController.clear();

                    // 방 생성 후 홈으로 이동
                    context.go('/home');
                  } catch (e) {
                    print('Error during room creation or notification: $e');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('오류 발생: ${e.toString()}')),
                    );
                  }
                } else {
                  // 필수 입력 항목이 누락된 경우 경고 메시지 표시
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('모든 필드를 입력해주세요.')),
                  );
                }
              },
              child: const Text(
                '방 생성',
                style:
                    TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
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
    return picked;
  }
}
