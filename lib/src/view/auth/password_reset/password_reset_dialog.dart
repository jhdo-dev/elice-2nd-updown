import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

class PasswordResetDialog extends StatefulWidget {
  const PasswordResetDialog({super.key});

  @override
  _PasswordResetDialogState createState() => _PasswordResetDialogState();
}

class _PasswordResetDialogState extends State<PasswordResetDialog> {
  final _emailController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  Future<void> _sendPasswordResetEmail() async {
    FocusScope.of(context).unfocus();
    setState(() {
      _isLoading = true; // 로딩 상태 시작
    });

    final email = _emailController.text;

    if (email.isNotEmpty) {
      try {
        await _auth.sendPasswordResetEmail(email: email);

        context.pop();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Password reset email sent to $email')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send reset email: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your email address.')),
      );
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: AlertDialog(
        title: const Text('Password Reset'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Enter your Email'),
              keyboardType: TextInputType.emailAddress,
            ),
          ],
        ),
        actions: [
          Center(
            child: _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _sendPasswordResetEmail,
                    child: const Text('Send Password Reset Email'),
                  ),
          ),
        ],
      ),
    );
  }
}
