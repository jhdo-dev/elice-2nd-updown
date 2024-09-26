// lib/src/home/home_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:up_down/src/view/home/home_view_model.dart';
import 'package:up_down/src/view/home/widgets/popular_room_card.dart';
import 'package:up_down/src/view/home/widgets/room_list.dart';
import 'package:go_router/go_router.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final popularRoomsAsyncValue = ref.watch(popularRoomsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Column(
        children: [
          // 인기 방 섹션
          SizedBox(
            height: 200,
            child: popularRoomsAsyncValue.when(
              data: (rooms) {
                if (rooms.isEmpty) {
                  return const Center(child: Text('No popular rooms'));
                }
                return PageView(
                  children: rooms.map((room) {
                    return PopularRoomCard(
                      roomName: room.roomName,
                      personName: room.personName,
                      imageUrl: room.imageUrl,
                      participantCount: room.participantCount, // 추가된 필드
                    );
                  }).toList(),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Error: $error')),
            ),
          ),
          // 방 리스트
          const Expanded(child: RoomListPage()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.go('/create-room');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
