// lib/src/view/home/home_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:up_down/src/provider/admin_repository_provider.dart';
import 'package:up_down/src/view/home/home_view_model.dart';
import 'package:up_down/src/view/home/widgets/popular_room_card.dart';
import 'package:up_down/src/view/home/widgets/room_list.dart';
import 'package:go_router/go_router.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeViewModelProvider);
    final isAdminAsyncValue = ref.watch(isAdminProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Column(
        children: [
          // 인기 방 섹션
          SizedBox(
            height: 200,
            child: homeState.popularRooms.isEmpty
                ? const Center(child: Text('No popular rooms'))
                : PageView(
                    children: homeState.popularRooms.map((room) {
                      return PopularRoomCard(
                        roomId: room.roomId,
                        roomName: room.roomName,
                        personName: room.personName,
                        imageUrl: room.imageUrl,
                        participantCount: room.participantCount,
                      );
                    }).toList(),
                  ),
          ),
          // 방 리스트
          const Expanded(child: RoomListPage()),
        ],
      ),
      floatingActionButton: isAdminAsyncValue.when(
        // 투표테스트
        data: (isAdmin) => isAdmin
            ? FloatingActionButton(
                onPressed: () {
                  context.go('/create-room');
                },
                child: const Icon(Icons.add),
              )
            : null, // isAdmin이 false인 경우 버튼을 표시하지 않음
        loading: () => const SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 2),
        ), // 로딩 중일 때 스피너 표시
        error: (error, stack) {
          // 에러 발생 시 사용자에게 알림 표시
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Failed to load admin status')),
            );
          });
          return null;
        },
      ),
    );
  }
}
