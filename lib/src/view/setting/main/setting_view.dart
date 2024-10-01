import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../component/error_dialog.dart';
import '../../../../util/helper/firebase_helper.dart';
import '../../../model/custom_error.dart';
import '../../../provider/auth_repository_provider.dart';

class SettingView extends ConsumerStatefulWidget {
  const SettingView({super.key});

  @override
  _SettingViewState createState() => _SettingViewState();
}

class _SettingViewState extends ConsumerState<SettingView> {
  Future<void> _signOut() async {
    try {
      await ref.read(authRepositoryProvider).signout();
    } on CustomError catch (e) {
      if (!mounted) return;
      errorDialog(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final uid = fbAuth.currentUser!.uid;
    // final profileState = ref.watch(profileProvider(uid));

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Welcome!'),
            // Text('name: ${_user?.displayName}'),
            // Text('email: ${_user?.email}'),
            // Text('photo: ${_user?.photoURL}'),
            ElevatedButton(
              onPressed: _signOut,
              child: const Text('Sign out'),
            ),
          ],
        ),
      ),
    );
  }
}
