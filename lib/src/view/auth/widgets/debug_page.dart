import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

// 디버깅용 페이지

class DebugPage extends StatefulWidget {
  const DebugPage({super.key});

  @override
  State<DebugPage> createState() => _DebugPageState();
}

class _DebugPageState extends State<DebugPage> {
  final _auth = FirebaseAuth.instance; // 로그아웃용
  final _user = FirebaseAuth.instance.currentUser; // 유저정보 출력용

  Future<void> _signOut() async {
    try {
      // Firebase Authentication을 사용하여 로그아웃을 구현하세요.
      await _auth.signOut();
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('userId');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Successfully signed out!')),
      );

      context.go('/auth');
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
            const Text('Welcome!'),
            Text('name: ${_user?.displayName}'),
            Text('email: ${_user?.email}'),
            Text('photo: ${_user?.photoURL}'),
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
