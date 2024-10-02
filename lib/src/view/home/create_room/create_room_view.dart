import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:up_down/services/fcm/fcm_service.dart';
import 'package:up_down/src/view/home/create_room/create_room_view_model.dart';

class CreateRoomView extends ConsumerStatefulWidget {
  const CreateRoomView({super.key});

  @override
  ConsumerState<CreateRoomView> createState() => _CreateRoomViewState();
}

class _CreateRoomViewState extends ConsumerState<CreateRoomView> {
  final TextEditingController personNameController = TextEditingController();
  final TextEditingController roomNameController = TextEditingController();

  // PushNotificationService 인스턴스 추가
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
        // 방 생성 버튼을 체크 아이콘으로 변경하여 AppBar에 추가
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () async {
              // 입력 필드 및 날짜 선택 상태 확인
              if (personNameController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('인물 이름을 입력해주세요.')),
                );
                return;
              }

              if (roomNameController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('논란 제목을 입력해주세요.')),
                );
                return;
              }

              if (state.roomStartDate == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('방 시작 날짜를 선택해주세요.')),
                );
                return;
              }

              if (state.roomEndDate == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('방 종료 날짜를 선택해주세요.')),
                );
                return;
              }

              // 모든 필드가 입력되었을 때 방 생성 로직 실행
              await viewModel.createRoom(
                personNameController.text,
                roomNameController.text,
              );

              // 입력 필드 초기화
              personNameController.clear();
              roomNameController.clear();

              // 방 생성 후 홈으로 이동
              context.go('/home');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          children: [
            TextField(
              controller: personNameController,
              decoration: const InputDecoration(labelText: '인물 이름을 입력해주세요.'),
            ),
            TextField(
              controller: roomNameController,
              decoration: const InputDecoration(labelText: '논란 제목을 입력해주세요.'),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () async {
                await viewModel.pickAndUploadImage();
              },
              child: Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    state.imageUrl == null ? '이미지 선택' : '이미지 업로드 완료',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 50),
            GestureDetector(
              onTap: () async {
                final pickedDate = await selectDate(context);
                if (pickedDate != null) {
                  viewModel.setRoomStartDate(pickedDate);
                }
              },
              child: Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    state.roomStartDate == null
                        ? '방 시작 날짜 선택'
                        : '방 시작 날짜: ${state.roomStartDate!.toLocal().toString().substring(0, 10)}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () async {
                final pickedDate = await selectDate(context);
                if (pickedDate != null) {
                  viewModel.setRoomEndDate(pickedDate);
                }
              },
              child: Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    state.roomEndDate == null
                        ? '방 종료 날짜 선택'
                        : '방 종료 날짜: ${state.roomEndDate!.toLocal().toString().substring(0, 10)}',
                    style: const TextStyle(color: Colors.white),
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
    return picked;
  }
}
