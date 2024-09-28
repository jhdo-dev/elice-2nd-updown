// lib/src/repository/home_repository.dart

import 'package:up_down/src/model/room.dart';

abstract class HomeRepository {
  Stream<List<Room>> getPopularRooms();
  Stream<List<Room>> getChatRooms();
  Future<void> createRoom(String roomName, String personName,
      DateTime roomStartDate, DateTime roomEndDate, String imageUrl);
  Future<void> addParticipant(String roomId, String userId);
  Future<void> removeParticipant(String roomId, String userId);
}
