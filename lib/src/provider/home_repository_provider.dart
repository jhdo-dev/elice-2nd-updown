// lib/src/provider/home_repository_provider.dart

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:up_down/src/repository/home_repository.dart';
import 'package:up_down/src/repository/home_repository_impl.dart';

part 'home_repository_provider.g.dart';

@Riverpod(keepAlive: true)
FirebaseFirestore firebaseFirestore(FirebaseFirestoreRef ref) {
  return FirebaseFirestore.instance;
}

@Riverpod(keepAlive: true)
HomeRepository homeRepository(HomeRepositoryRef ref) {
  final firestore = ref.watch(firebaseFirestoreProvider);
  return HomeRepositoryImpl(firestore: firestore);
}
