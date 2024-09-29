import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:up_down/src/view/auth/password_reset/password_reset_dialog.dart';

import '../../../component/error_dialog.dart';
import '../../../component/form_fields.dart';
import '../../model/custom_error.dart';
import 'sign_up/sign_up_dialog.dart';
import 'auth_view_provider.dart';

class AuthView extends ConsumerStatefulWidget {
  const AuthView({super.key});

  @override
  _AuthViewState createState() => _AuthViewState();
}

class _AuthViewState extends ConsumerState<AuthView> {
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;

//이메일 로그인
  Future<void> _signInWithEmail() async {
    FocusScope.of(context).unfocus();
    setState(() => _autovalidateMode = AutovalidateMode.always);

    final form = _formKey.currentState;

    if (form == null || !form.validate()) return;

    ref.read(signInProvider.notifier).signInWithEmail(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
  }

// 구글 로그인
  final _googleSignIn = GoogleSignIn();
  final _auth = FirebaseAuth.instance;
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
      final newUser = await _auth.signInWithCredential(credential);

      await FirebaseFirestore.instance
          .collection('users')
          .doc(newUser.user!.uid)
          .set({
        'name': newUser.user!.displayName,
        'email': newUser.user!.email,
        // 'photo': photo.url,
        'isAdmin': false,
      });

      context.go('/home');
    } catch (e) {
      print('Error signing in with Google: $e');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to sign in with Google: $e')),
      );
    }
  }

  //페이스북 로그인
  Future<void> _signInWithFacebook() async {
    //^
    try {
      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.success) {
        final AccessToken accessToken = result.accessToken!;

        final OAuthCredential credential =
            FacebookAuthProvider.credential(accessToken.tokenString);

        final UserCredential userCredential =
            await _auth.signInWithCredential(credential);

        context.go('/home');
      } else {
        throw Exception('Facebook login failed');
      }
    } catch (e) {
      print('Error signing in with Facebook: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to sign in with Facebook: $e')),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(signInProvider, (prev, next) {
      next.whenOrNull(
        error: (e, st) => errorDialog(context, e as CustomError),
        data: (_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content:
                  Text('Hello, [username]! You\'ve successfully signed in.'),
            ),
          );
        },
      );
    });

    final signinState = ref.watch(signInProvider);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Auth View'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            autovalidateMode: _autovalidateMode,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                EmailFormField(emailController: _emailController),
                PasswordFormField(passwordController: _passwordController),
                Row(
                  children: [
                    Checkbox(
                      value: _rememberMe,
                      onChanged: (value) {
                        setState(() {
                          _rememberMe = value ?? false;
                        });
                      },
                    ),
                    GestureDetector(
                      onTap: () => setState(() {
                        _rememberMe = !_rememberMe;
                      }),
                      child: const Text('Remember Me'),
                    ),
                  ],
                ),
                signinState.maybeWhen(
                  loading: () => const CircularProgressIndicator(),
                  orElse: () => ElevatedButton(
                    onPressed: _signInWithEmail,
                    child: const Text('SIGN IN'),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const PasswordResetDialog();
                      },
                    );
                  },
                  child: const Text('Forgot your password?'),
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Divider(
                        endIndent: 20,
                      ),
                    ),
                    Text('or'),
                    Expanded(
                      child: Divider(
                        indent: 20,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton(
                      onPressed: _signInWithGoogle,
                      child: Image.asset(
                        "assets/icons/google.png",
                        width: 25,
                        fit: BoxFit.fill,
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    OutlinedButton(
                      onPressed: _signInWithFacebook,
                      child: Image.asset(
                        "assets/icons/facebook.png",
                        width: 25,
                        fit: BoxFit.fill,
                        color: const Color(0xFF0966FF),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Don\'t have an account?'),
                    TextButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return const SignUpDialog();
                          },
                        );
                      },
                      child: const Text('Get Started'),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
