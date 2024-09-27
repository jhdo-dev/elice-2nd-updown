// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$adminRepositoryHash() => r'aa9f8142f4e9e3ecbe1ff2044b363e27460131d6';

/// See also [adminRepository].
@ProviderFor(adminRepository)
final adminRepositoryProvider = AutoDisposeProvider<AdminRepository>.internal(
  adminRepository,
  name: r'adminRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$adminRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AdminRepositoryRef = AutoDisposeProviderRef<AdminRepository>;
String _$isAdminHash() => r'776aefa48a1368ce9685de07afa9ee0ecd8e07ed';

/// See also [isAdmin].
@ProviderFor(isAdmin)
final isAdminProvider = AutoDisposeStreamProvider<bool>.internal(
  isAdmin,
  name: r'isAdminProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$isAdminHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef IsAdminRef = AutoDisposeStreamProviderRef<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
