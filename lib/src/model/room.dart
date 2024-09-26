// lib/src/model/room.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'room.freezed.dart';
part 'room.g.dart';

@freezed
class Room with _$Room {
  const factory Room({
    required String roomId,
    required String roomName,
    required String personName,
    required String imageUrl,
    required DateTime roomStartDate,
    required DateTime roomEndDate,
    @Default(0) int participantCount,
  }) = _Room;

  factory Room.fromJson(Map<String, dynamic> json) => _$RoomFromJson(json);

  factory Room.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    return Room.fromJson({
      ...doc.data()!,
      'roomId': doc.id,
    });
  }
}
