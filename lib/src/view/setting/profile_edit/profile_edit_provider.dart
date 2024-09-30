import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:up_down/src/provider/auth_repository_provider.dart';

import '../../../model/app_user.dart';
import '../../../provider/profile_repository_provider.dart';
import '../profile/profile_provider.dart';

part 'profile_edit_provider.g.dart';

@riverpod
class ProfileEdit extends _$ProfileEdit {
  @override
  FutureOr<void> build() {}

  Future<void> changePassword(String password) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard<void>(
      () => ref.read(authRepositoryProvider).changePassword(password),
    );
  }

  Future<void> changeUserName(String newName) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard<void>(
      () => ref.read(authRepositoryProvider).updateUserName(newName),
    );
  }

  FutureOr<AppUser> profile(ProfileRef ref, String uid) {
    return ref.watch(profileRepositoryProvider).getProfile(uid: uid);
  }
}
