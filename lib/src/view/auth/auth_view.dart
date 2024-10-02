import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:up_down/src/provider/auth_repository_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  bool _rememberMe = true;

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
  Future<void> _signInWithGoogle() async {
    try {
      await ref.read(signInProvider.notifier).signInWithGoogle();
    } catch (e) {
      print('Error signing in with Google: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to sign in with Google: $e')),
      );
    }
  }

  //페이스북 로그인
  // Future<void> _signInWithFacebook() async {
  //   //^
  //   try {
  //     final LoginResult result = await FacebookAuth.instance.login();

  //     if (result.status == LoginStatus.success) {
  //       final AccessToken accessToken = result.accessToken!;

  //       final OAuthCredential credential =
  //           FacebookAuthProvider.credential(accessToken.tokenString);

  //       // final UserCredential userCredential =
  //       //     await _auth.signInWithCredential(credential);

  //       if (!mounted) return;
  //       context.go('/home');
  //     } else {
  //       throw Exception('Facebook login failed');
  //     }
  //   } catch (e) {
  //     print('Error signing in with Facebook: $e');
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Failed to sign in with Facebook: $e')),
  //     );
  //   }
  // }

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
                    OutlinedButton(
                      onPressed: () async {
                        try {
                          await ref
                              .read(authRepositoryProvider)
                              .signInWithKakao();
                          if (!mounted) return;
                          context.go('/home'); // 로그인 성공 후 홈 화면으로 이동
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content:
                                    Text('Failed to sign in with Kakao: $e')),
                          );
                        }
                      },
                      child: Image.asset(
                        "assets/images/kakao_login_medium_narrow.png",
                        width: 25,
                        fit: BoxFit.fill,
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    // OutlinedButton(
                    //   onPressed: _signInWithFacebook,
                    //   child: Image.asset(
                    //     "assets/icons/facebook.png",
                    //     width: 25,
                    //     fit: BoxFit.fill,
                    //     color: const Color(0xFF0966FF),
                    //   ),
                    // ),
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
