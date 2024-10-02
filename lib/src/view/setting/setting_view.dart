import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:up_down/src/view/setting/change_name/change_name_dialog.dart';
import 'package:up_down/src/view/setting/change_password/change_password_dialog.dart';
import 'package:up_down/src/view/setting/push_notification_toggle/push_notification_toggle.dart';
import 'package:up_down/src/view/setting/reauthenticate/reauthenticate_dialog.dart';
import 'package:up_down/src/view/setting/theme_toggle/theme_toggle.dart';

import '../../../component/error_dialog.dart';
import '../../../util/helper/firebase_helper.dart';
import '../../model/custom_error.dart';
import '../../provider/auth_repository_provider.dart';
import 'delete_account/delete_account_dialog.dart';
import 'setting_provider.dart';

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
      ),
      body: profileState.when(
        skipLoadingOnRefresh: false,
        data: (appUser) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Card(
                  child: ListTile(
                    leading: const FlutterLogo(size: 72.0),
                    title: Text(appUser.name),
                    subtitle: Text(appUser.email),
                    contentPadding: const EdgeInsets.all(20),
                  ),
                ),
                // const FlutterLogo(size: 72.0),
                // Text(appUser.name),
                // Text(appUser.email),
                // https://aliencoder.tistory.com/81
                ListTile(
                  title: const Text('Change Name'),
                  onTap: () => showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const ChangeNameDialog();
                    },
                  ),
                ),
                ListTile(
                  title: const Text('Change Password'),
                  onTap: () async {
                    final result = await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const ReauthenticateDialog();
                      },
                    );
                    if (result == 'success' && context.mounted) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const ChangePasswordDialog();
                        },
                      );
                    }
                  },
                ),
                const PushNotificationToggle(),
                const ThemeToggle(),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Sign Out'),
                        content:
                            const Text('Are you sure you want to sign out?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              context.pop();
                            },
                            child: const Text('Cancle'),
                          ),
                          TextButton(
                            onPressed: () => _signOut(),
                            child: const Text('Sign Out'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: const Text('Sign out'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final result = await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const ReauthenticateDialog();
                      },
                    );
                    if (result == 'success' && context.mounted) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const DeleteAccountDialog();
                        },
                      );
                    }
                  },
                  child: const Text('Delete Account'),
                ),
              ],
            ),
          );
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
