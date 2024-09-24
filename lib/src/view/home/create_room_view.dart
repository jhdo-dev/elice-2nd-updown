import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:up_down/src/view/home/home_view_model.dart'; // 여기에서 homeViewModelProvider를 가져옴

class CreateRoomView extends ConsumerWidget {
  final TextEditingController _roomNameController = TextEditingController();
  final TextEditingController _personNameController = TextEditingController();
  final TextEditingController _roomStartDateController =
      TextEditingController();
  final TextEditingController _roomEndDateController = TextEditingController();

  CreateRoomView({super.key});

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      // 선택한 날짜를 형식에 맞게 설정
      controller.text =
          "${picked.month.toString().padLeft(2, '0')}/${picked.day.toString().padLeft(2, '0')}";
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('방 생성'), // 페이지 제목
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _personNameController,
              decoration: const InputDecoration(
                labelText: '인물 이름',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _roomNameController,
              decoration: const InputDecoration(
                labelText: '방 이름',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _roomStartDateController,
              decoration: const InputDecoration(
                labelText: '시작일 (MM/DD)',
                border: OutlineInputBorder(),
              ),
              onTap: () =>
                  _selectDate(context, _roomStartDateController), // 날짜 선택
              readOnly: true, // 사용자가 텍스트 필드에 직접 입력하지 못하도록 설정
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _roomEndDateController,
              decoration: const InputDecoration(
                labelText: '종료일 (MM/DD)',
                border: OutlineInputBorder(),
              ),
              onTap: () =>
                  _selectDate(context, _roomEndDateController), // 날짜 선택
              readOnly: true, // 사용자가 텍스트 필드에 직접 입력하지 못하도록 설정
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // 이미지 업로드 로직 구현
              },
              child: const Text('이미지 업로드'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final roomName = _roomNameController.text.trim();
                final personName = _personNameController.text.trim();
                final roomStartDate = _roomStartDateController.text.trim();
                final roomEndDate = _roomEndDateController.text.trim();

                if (roomName.isNotEmpty &&
                    personName.isNotEmpty &&
                    roomStartDate.isNotEmpty &&
                    roomEndDate.isNotEmpty) {
                  // Firestore에 방 생성 로직
                  await ref.read(homeViewModelProvider).createRoom(
                      roomName, personName, roomStartDate, roomEndDate);
                  // 방 생성 후 홈 페이지로 돌아가기
                  // ignore: use_build_context_synchronously
                  context.go('/home'); // GoRouter를 사용하여 페이지 이동
                }
              },
              child: const Text('방 생성'),
            ),
          ],
        ),
      ),
    );
  }
}
