// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_view_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$HomeViewState {
  List<Room> get popularRooms => throw _privateConstructorUsedError;
  Room? get selectedRoom => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Create a copy of HomeViewState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HomeViewStateCopyWith<HomeViewState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HomeViewStateCopyWith<$Res> {
  factory $HomeViewStateCopyWith(
          HomeViewState value, $Res Function(HomeViewState) then) =
      _$HomeViewStateCopyWithImpl<$Res, HomeViewState>;
  @useResult
  $Res call(
      {List<Room> popularRooms,
      Room? selectedRoom,
      bool isLoading,
      String? errorMessage});

  $RoomCopyWith<$Res>? get selectedRoom;
}

/// @nodoc
class _$HomeViewStateCopyWithImpl<$Res, $Val extends HomeViewState>
    implements $HomeViewStateCopyWith<$Res> {
  _$HomeViewStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HomeViewState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? popularRooms = null,
    Object? selectedRoom = freezed,
    Object? isLoading = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_value.copyWith(
      popularRooms: null == popularRooms
          ? _value.popularRooms
          : popularRooms // ignore: cast_nullable_to_non_nullable
              as List<Room>,
      selectedRoom: freezed == selectedRoom
          ? _value.selectedRoom
          : selectedRoom // ignore: cast_nullable_to_non_nullable
              as Room?,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  /// Create a copy of HomeViewState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RoomCopyWith<$Res>? get selectedRoom {
    if (_value.selectedRoom == null) {
      return null;
    }

    return $RoomCopyWith<$Res>(_value.selectedRoom!, (value) {
      return _then(_value.copyWith(selectedRoom: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$HomeViewStateImplCopyWith<$Res>
    implements $HomeViewStateCopyWith<$Res> {
  factory _$$HomeViewStateImplCopyWith(
          _$HomeViewStateImpl value, $Res Function(_$HomeViewStateImpl) then) =
      __$$HomeViewStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<Room> popularRooms,
      Room? selectedRoom,
      bool isLoading,
      String? errorMessage});

  @override
  $RoomCopyWith<$Res>? get selectedRoom;
}

/// @nodoc
class __$$HomeViewStateImplCopyWithImpl<$Res>
    extends _$HomeViewStateCopyWithImpl<$Res, _$HomeViewStateImpl>
    implements _$$HomeViewStateImplCopyWith<$Res> {
  __$$HomeViewStateImplCopyWithImpl(
      _$HomeViewStateImpl _value, $Res Function(_$HomeViewStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of HomeViewState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? popularRooms = null,
    Object? selectedRoom = freezed,
    Object? isLoading = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_$HomeViewStateImpl(
      popularRooms: null == popularRooms
          ? _value._popularRooms
          : popularRooms // ignore: cast_nullable_to_non_nullable
              as List<Room>,
      selectedRoom: freezed == selectedRoom
          ? _value.selectedRoom
          : selectedRoom // ignore: cast_nullable_to_non_nullable
              as Room?,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$HomeViewStateImpl implements _HomeViewState {
  _$HomeViewStateImpl(
      {final List<Room> popularRooms = const [],
      this.selectedRoom,
      this.isLoading = false,
      this.errorMessage})
      : _popularRooms = popularRooms;

  final List<Room> _popularRooms;
  @override
  @JsonKey()
  List<Room> get popularRooms {
    if (_popularRooms is EqualUnmodifiableListView) return _popularRooms;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_popularRooms);
  }

  @override
  final Room? selectedRoom;
  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'HomeViewState(popularRooms: $popularRooms, selectedRoom: $selectedRoom, isLoading: $isLoading, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HomeViewStateImpl &&
            const DeepCollectionEquality()
                .equals(other._popularRooms, _popularRooms) &&
            (identical(other.selectedRoom, selectedRoom) ||
                other.selectedRoom == selectedRoom) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_popularRooms),
      selectedRoom,
      isLoading,
      errorMessage);

  /// Create a copy of HomeViewState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HomeViewStateImplCopyWith<_$HomeViewStateImpl> get copyWith =>
      __$$HomeViewStateImplCopyWithImpl<_$HomeViewStateImpl>(this, _$identity);
}

abstract class _HomeViewState implements HomeViewState {
  factory _HomeViewState(
      {final List<Room> popularRooms,
      final Room? selectedRoom,
      final bool isLoading,
      final String? errorMessage}) = _$HomeViewStateImpl;

  @override
  List<Room> get popularRooms;
  @override
  Room? get selectedRoom;
  @override
  bool get isLoading;
  @override
  String? get errorMessage;

  /// Create a copy of HomeViewState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HomeViewStateImplCopyWith<_$HomeViewStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
