// lib/src/home/widgets/popular_room_card.dart
import 'package:flutter/material.dart';

class PopularRoomCard extends StatelessWidget {
  final String roomName;
  final String personName;
  final String imageUrl;
  final int participantCount; // 추가된 필드

  const PopularRoomCard({
    super.key,
    required this.roomName,
    required this.personName,
    required this.imageUrl,
    required this.participantCount,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(
            imageUrl,
            width: 100,
            height: 100,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.error, size: 100, color: Colors.red);
            },
          ),
          const SizedBox(height: 8),
          Text(
            personName,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            roomName,
            style: const TextStyle(fontSize: 16),
          ),
          Text(
            'Participants: $participantCount',
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
