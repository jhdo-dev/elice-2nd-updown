import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:up_down/src/view/auth/auth_view.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final _auth = FirebaseAuth.instance;

  Future<void> _signOut() async {
    try {
      // Firebase Authentication을 사용하여 로그아웃을 구현하세요.
      await _auth.signOut();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Successfully signed out!')),
      );

      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => SignInPage(),
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign out failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Welcome'),
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
