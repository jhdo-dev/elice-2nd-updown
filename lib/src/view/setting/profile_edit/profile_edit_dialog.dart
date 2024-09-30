import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../component/error_dialog.dart';
import '../../../../component/form_fields.dart';
import '../../../../util/helper/firebase_helper.dart';
import '../../../model/custom_error.dart';
import '../profile/profile_provider.dart';
import 'profile_edit_provider.dart';

class ProfileEditDialog extends ConsumerStatefulWidget {
  const ProfileEditDialog({super.key});

  @override
  _ProfileEditDialogState createState() => _ProfileEditDialogState();
}

class _ProfileEditDialogState extends ConsumerState<ProfileEditDialog> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  @override
  void initState() {
    super.initState();
    // 초기 상태 설정
    final uid = fbAuth.currentUser!.uid;
    final profileState = ref.read(profileProvider(uid));
    profileState.whenData((profile) {
      _emailController.text = profile.email;
      _nameController.text = profile.name;
    });
  }

  void _submit() async {
    FocusScope.of(context).unfocus();
    setState(() => _autovalidateMode = AutovalidateMode.always);

    final form = _formKey.currentState;

    if (form == null || !form.validate()) return;

    final profileEdit = ref.read(profileEditProvider.notifier);

    // 사용자 이름 변경
    await profileEdit.changeUserName(_nameController.text.trim());

    // 비밀번호 변경
    await profileEdit.changePassword(_passwordController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    final uid = fbAuth.currentUser!.uid;
    final profileState = ref.watch(profileProvider(uid));
    final profileEditState = ref.watch(profileEditProvider);

    ref.listen<AsyncValue<void>>(
      profileEditProvider,
      (previous, next) {
        next.whenOrNull(
          error: (e, st) {
            errorDialog(context, e as CustomError);
          },
          data: (_) {
            ref.invalidate(profileProvider);
            GoRouter.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Your profile has been updated'),
              ),
            );
          },
        );
      },
    );

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: AlertDialog(
        title: const Text('Edit Profile'),
        content: profileEditState.when(
          data: (profile) => Form(
            key: _formKey,
            autovalidateMode: _autovalidateMode,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                NameFormField(nameController: _nameController),
                TextFormField(
                  controller: _emailController,
                  enabled: false,
                ),
                PasswordFormField(passwordController: _passwordController),
                ConfirmPasswordFormField(
                    passwordController: _passwordController),
              ],
            ),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text('Error: $error')),
        ),
        actions: [
          Center(
              child: profileEditState.maybeWhen(
            loading: () => const CircularProgressIndicator(),
            orElse: () => ElevatedButton(
              onPressed: _submit,
              child: const Text('Save'),
            ),
          )),
        ],
      ),
    );
  }
}
