import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:up_down/src/model/custom_error.dart';
import 'package:up_down/src/provider/auth_repository_provider.dart';
import 'package:up_down/util/helper/firebase_helper.dart';
import 'package:up_down/util/router/route_names.dart';

import '../../../../component/error_dialog.dart';
import 'profile_provider.dart';

class ProfileWidget extends ConsumerWidget {
  const ProfileWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uid = fbAuth.currentUser!.uid;
    final profileState = ref.watch(profileProvider(uid));

    return profileState.when(
      skipLoadingOnRefresh: false,
      data: (appUser) {
        return const Card();
      },
      error: (e, _) {
        final error = e as CustomError;
        return Center(
          child: Text(
            'code: ${error.code}\nplugin: ${error.plugin}\nmessage: ${error.message}',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.red,
              fontSize: 18,
            ),
          ),
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
