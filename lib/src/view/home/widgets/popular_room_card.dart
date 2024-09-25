import 'package:flutter/material.dart';

class PopularRoomCard extends StatelessWidget {
  final String roomName;

  const PopularRoomCard({
    super.key,
    required this.roomName,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      color: Colors.white,
      child: Center(
        child: Text(
          roomName,
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
