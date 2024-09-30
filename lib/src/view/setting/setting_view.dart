import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:up_down/src/view/setting/profile/profile_widget.dart';
import 'package:up_down/src/view/setting/push_notification_toggle/push_notification_toggle.dart';
import 'package:up_down/src/view/setting/theme_toggle/theme_toggle.dart';

import '../../../component/error_dialog.dart';
import '../../../util/helper/firebase_helper.dart';
import '../../../util/router/route_names.dart';
import '../../model/custom_error.dart';
import '../../provider/auth_repository_provider.dart';
import 'profile/profile_provider.dart';
import 'profile_edit/profile_edit_dialog.dart';

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
    final profileState = ref.watch(profileProvider(uid));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Setting'),
        // actions: [
        //   IconButton(
        //     onPressed: () {
        //       ref.invalidate(profileProvider);
        //     },
        //     icon: const Icon(Icons.refresh),
        //   ),
        // ],
      ),
      body: profileState.when(
        skipLoadingOnRefresh: false,
        data: (appUser) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const FlutterLogo(size: 72.0),
                    Text(appUser.name),
                    Text(appUser.email),
                  ],
                ),
                // const ProfileWidget(),
                ListTile(
                  title: Text(appUser.name),
                  subtitle: Text(appUser.email),
                  trailing: IconButton(
                    icon: const Icon(Icons.settings),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const ProfileEditDialog();
                        },
                      );
                    },
                  ),
                ),
                ListTile(
                  title: Text(appUser.name),
                  subtitle: Text(appUser.email),
                  trailing: IconButton(
                    icon: const Icon(Icons.settings),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const ProfileEditDialog();
                        },
                      );
                    },
                  ),
                ),
                const PushNotificationToggle(),
                const ThemeToggle(),
                ElevatedButton(
                  onPressed: _signOut,
                  child: const Text('Sign out'),
                ),
              ],
            ),
          );
          // 디버그용
          // Center(
          //   child: Column(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       const ProfileWidget(),
          //       const Text('Welcome!'),
          //       Text('name: ${appUser.name}'),
          //       Text('email: ${appUser.email}'),
          //       // Text('photo: ${appUser.photoURL}'),

          //       ElevatedButton(
          //         onPressed: () {
          //           // GoRouter.of(context).goNamed(RouteNames.changePassword);
          //         },
          //         child: const Text('Change Password'),
          //       )
          //     ],
          //   ),
          // );
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
      ),
    );
  }
}
