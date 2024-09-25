import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    // Firebase 인증 상태 변경을 감지하여 _user 상태를 업데이트합니다.
    _auth.authStateChanges().listen((User? user) {
      setState(() {});
    });
  }

  Future<void> _signUp() async {
    FocusScope.of(context).unfocus();
    setState(() {
      _isLoading = true; // 로딩 상태 시작
    });

    final email = _emailController.text;
    final password = _passwordController.text;
    final name = _nameController.text;

    if (email.isNotEmpty && password.isNotEmpty) {
      try {
        final userCredential = await _auth.createUserWithEmailAndPassword(
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
          SnackBar(
            content: Text(
              'Sign Up Successful! Welcome, $name',
            ),
          ),
        );

        context.go('/auth');
      } catch (e) {
        print('Error: $e');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sign Up Failed: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter both email and password.')),
      );
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Sign Up Page'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
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
              const SizedBox(height: 20),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _signUp,
                      child: const Text('Sign Up'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();

final TextEditingController _emailController = TextEditingController();
final TextEditingController _passwordController = TextEditingController();

Future<void> _signUpWithEmail() async {
  final email = _emailController.text;
  final password = _passwordController.text;

  if (email.isNotEmpty && password.isNotEmpty) {
    try {
      // Firebase Authentication을 사용하여 회원가입을 구현합니다.
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Firestore에 사용자 정보를 저장합니다.
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'displayName': userCredential.user!.displayName,
        'email': userCredential.user!.email,
        'photoURL': userCredential.user!.photoURL,
        'lastSignInTime': userCredential.user!.metadata.lastSignInTime,
        'creationTime': userCredential.user!.metadata.creationTime,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Sign Up Successful! Welcome, ${userCredential.user?.email}',
          ),
        ),
      );

      _emailController.clear();
      _passwordController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign Up Failed: $e')),
      );
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Please enter both email and password')),
    );
  }
}

Future<void> _signInWithGoogle() async {
  try {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

    if (googleUser == null) {
      return;
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    UserCredential userCredential =
        await _auth.signInWithCredential(credential);

    final User? user = userCredential.user;

    if (user != null) {
      // Firestore에 사용자 정보를 저장합니다.
      final userDoc = _firestore.collection('users').doc(user.uid);
      final docSnapshot = await userDoc.get();

      if (!docSnapshot.exists) {
        await userDoc.set({
          'displayName': user.displayName,
          'email': user.email,
          'photoURL': user.photoURL,
          'lastSignInTime': user.metadata.lastSignInTime,
          'creationTime': user.metadata.creationTime,
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign In Successful! Welcome, ${user.displayName}')),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Sign In Failed: $e')),
    );
  }
}
 */