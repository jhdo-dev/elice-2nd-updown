import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';

class SignUpDialog extends StatefulWidget {
  const SignUpDialog({super.key});

  @override
  _SignUpDialogState createState() => _SignUpDialogState();
}

class _SignUpDialogState extends State<SignUpDialog> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  bool _isLoading = false;

  void _signUp() async {
    FocusScope.of(context).unfocus();
    setState(() {
      _isLoading = true;
    });

    final email = _emailController.text;
    final password = _passwordController.text;
    final name = _nameController.text;

    if (email.isNotEmpty && password.isNotEmpty) {
      try {
        final userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'name': name,
          'email': email,
          // 'photo': photo.url,
        });

        // 사용자 프로필 업데이트
        await userCredential.user?.updateProfile(displayName: name);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Sign up successful! Please sign in',
            ),
          ),
        );
        context.pop();
      } catch (e) {
        print('Error signing up: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to sign up: $e')),
        );
      } finally {}
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
    }
    setState(() {
      _isLoading = false;
    });
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
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: AlertDialog(
        title: const Text('Sign Up'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
          ],
        ),
        actions: [
          Center(
            child: _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _signUp,
                    child: const Text('Sign Up'),
                  ),
          ),
        ],
      ),
    );
  }
}
