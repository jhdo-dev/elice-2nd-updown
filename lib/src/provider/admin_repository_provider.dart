// lib/src/provider/admin_repository_provider.dart

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:up_down/src/repository/admin_repository.dart';

part 'admin_repository_provider.g.dart';

@riverpod
AdminRepository adminRepository(AdminRepositoryRef ref) {
  return AdminRepository();
}

@riverpod
Stream<bool> isAdmin(IsAdminRef ref) {
  final repository = ref.watch(adminRepositoryProvider);
  return repository.isCurrentUserAdminStream();
}
