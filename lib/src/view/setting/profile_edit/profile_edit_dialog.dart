import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:up_down/component/form_fields.dart';

import '../../../../component/error_dialog.dart';
import '../../../model/custom_error.dart';

class ProfileEditDialog extends ConsumerStatefulWidget {
  const ProfileEditDialog({super.key});

  @override
  _SignUpDialogState createState() => _SignUpDialogState();
}

class _SignUpDialogState extends ConsumerState<ProfileEditDialog> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  void _signUp() async {
    FocusScope.of(context).unfocus();
    setState(() => _autovalidateMode = AutovalidateMode.always);

    final form = _formKey.currentState;

    if (form == null || !form.validate()) return;

    ref.read(signupProvider.notifier).signup(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim());
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<void>>(
      signupProvider,
      (previous, next) {
        next.whenOrNull(
          error: (e, st) => errorDialog(context, e as CustomError),
          data: (_) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Welcome, username*! Thank you for joining us.'),
              ),
            );
          },
        );
      },
    );

    final signupState = ref.watch(signupProvider);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus,
      child: AlertDialog(
        title: const Text('Get Started'),
        content: Form(
          key: _formKey,
          autovalidateMode: _autovalidateMode,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              NameFormField(nameController: _nameController),
              EmailFormField(emailController: _emailController),
              PasswordFormField(passwordController: _passwordController),
              ConfirmPasswordFormField(passwordController: _passwordController),
            ],
          ),
        ),
        actions: [
          Center(
              child: signupState.maybeWhen(
            loading: () => const CircularProgressIndicator(),
            orElse: () => ElevatedButton(
              onPressed: _signUp,
              child: const Text('Save'),
            ),
          )),
        ],
      ),
    );
  }
}
