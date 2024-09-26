// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'room.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Room _$RoomFromJson(Map<String, dynamic> json) {
  return _Room.fromJson(json);
}

/// @nodoc
mixin _$Room {
  String get roomId => throw _privateConstructorUsedError;
  String get roomName => throw _privateConstructorUsedError;
  String get personName => throw _privateConstructorUsedError;
  String get imageUrl => throw _privateConstructorUsedError;
  DateTime get roomStartDate => throw _privateConstructorUsedError;
  DateTime get roomEndDate => throw _privateConstructorUsedError;
  int get participantCount => throw _privateConstructorUsedError;

  /// Serializes this Room to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Room
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RoomCopyWith<Room> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RoomCopyWith<$Res> {
  factory $RoomCopyWith(Room value, $Res Function(Room) then) =
      _$RoomCopyWithImpl<$Res, Room>;
  @useResult
  $Res call(
      {String roomId,
      String roomName,
      String personName,
      String imageUrl,
      DateTime roomStartDate,
      DateTime roomEndDate,
      int participantCount});
}

/// @nodoc
class _$RoomCopyWithImpl<$Res, $Val extends Room>
    implements $RoomCopyWith<$Res> {
  _$RoomCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Room
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? roomId = null,
    Object? roomName = null,
    Object? personName = null,
    Object? imageUrl = null,
    Object? roomStartDate = null,
    Object? roomEndDate = null,
    Object? participantCount = null,
  }) {
    return _then(_value.copyWith(
      roomId: null == roomId
          ? _value.roomId
          : roomId // ignore: cast_nullable_to_non_nullable
              as String,
      roomName: null == roomName
          ? _value.roomName
          : roomName // ignore: cast_nullable_to_non_nullable
              as String,
      personName: null == personName
          ? _value.personName
          : personName // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: null == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      roomStartDate: null == roomStartDate
          ? _value.roomStartDate
          : roomStartDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      roomEndDate: null == roomEndDate
          ? _value.roomEndDate
          : roomEndDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      participantCount: null == participantCount
          ? _value.participantCount
          : participantCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RoomImplCopyWith<$Res> implements $RoomCopyWith<$Res> {
  factory _$$RoomImplCopyWith(
          _$RoomImpl value, $Res Function(_$RoomImpl) then) =
      __$$RoomImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String roomId,
      String roomName,
      String personName,
      String imageUrl,
      DateTime roomStartDate,
      DateTime roomEndDate,
      int participantCount});
}

/// @nodoc
class __$$RoomImplCopyWithImpl<$Res>
    extends _$RoomCopyWithImpl<$Res, _$RoomImpl>
    implements _$$RoomImplCopyWith<$Res> {
  __$$RoomImplCopyWithImpl(_$RoomImpl _value, $Res Function(_$RoomImpl) _then)
      : super(_value, _then);

  /// Create a copy of Room
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? roomId = null,
    Object? roomName = null,
    Object? personName = null,
    Object? imageUrl = null,
    Object? roomStartDate = null,
    Object? roomEndDate = null,
    Object? participantCount = null,
  }) {
    return _then(_$RoomImpl(
      roomId: null == roomId
          ? _value.roomId
          : roomId // ignore: cast_nullable_to_non_nullable
              as String,
      roomName: null == roomName
          ? _value.roomName
          : roomName // ignore: cast_nullable_to_non_nullable
              as String,
      personName: null == personName
          ? _value.personName
          : personName // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: null == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      roomStartDate: null == roomStartDate
          ? _value.roomStartDate
          : roomStartDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      roomEndDate: null == roomEndDate
          ? _value.roomEndDate
          : roomEndDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      participantCount: null == participantCount
          ? _value.participantCount
          : participantCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RoomImpl implements _Room {
  const _$RoomImpl(
      {required this.roomId,
      required this.roomName,
      required this.personName,
      required this.imageUrl,
      required this.roomStartDate,
      required this.roomEndDate,
      this.participantCount = 0});

  factory _$RoomImpl.fromJson(Map<String, dynamic> json) =>
      _$$RoomImplFromJson(json);

  @override
  final String roomId;
  @override
  final String roomName;
  @override
  final String personName;
  @override
  final String imageUrl;
  @override
  final DateTime roomStartDate;
  @override
  final DateTime roomEndDate;
  @override
  @JsonKey()
  final int participantCount;

  @override
  String toString() {
    return 'Room(roomId: $roomId, roomName: $roomName, personName: $personName, imageUrl: $imageUrl, roomStartDate: $roomStartDate, roomEndDate: $roomEndDate, participantCount: $participantCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RoomImpl &&
            (identical(other.roomId, roomId) || other.roomId == roomId) &&
            (identical(other.roomName, roomName) ||
                other.roomName == roomName) &&
            (identical(other.personName, personName) ||
                other.personName == personName) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.roomStartDate, roomStartDate) ||
                other.roomStartDate == roomStartDate) &&
            (identical(other.roomEndDate, roomEndDate) ||
                other.roomEndDate == roomEndDate) &&
            (identical(other.participantCount, participantCount) ||
                other.participantCount == participantCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, roomId, roomName, personName,
      imageUrl, roomStartDate, roomEndDate, participantCount);

  /// Create a copy of Room
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RoomImplCopyWith<_$RoomImpl> get copyWith =>
      __$$RoomImplCopyWithImpl<_$RoomImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RoomImplToJson(
      this,
    );
  }
}

abstract class _Room implements Room {
  const factory _Room(
      {required final String roomId,
      required final String roomName,
      required final String personName,
      required final String imageUrl,
      required final DateTime roomStartDate,
      required final DateTime roomEndDate,
      final int participantCount}) = _$RoomImpl;

  factory _Room.fromJson(Map<String, dynamic> json) = _$RoomImpl.fromJson;

  @override
  String get roomId;
  @override
  String get roomName;
  @override
  String get personName;
  @override
  String get imageUrl;
  @override
  DateTime get roomStartDate;
  @override
  DateTime get roomEndDate;
  @override
  int get participantCount;

  /// Create a copy of Room
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RoomImplCopyWith<_$RoomImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
