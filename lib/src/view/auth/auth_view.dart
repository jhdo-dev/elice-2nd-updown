import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:up_down/src/view/auth/pages/sign_up_page.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> _signInWithGoogle() async {
    try {
      // 사용자가 Google 계정을 선택하고 로그인하도록 합니다.
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      // 사용자가 로그인하지 않고 프로세스를 취소한 경우
      if (googleUser == null) {
        return;
      }

      // GoogleSignInAuthentication 객체를 통해 인증 정보를 가져옵니다.
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Google 인증 정보를 사용하여 Firebase에 로그인합니다.
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      // Firebase에 로그인합니다.
      await _auth.signInWithCredential(credential);

      context.go('/auth');
    } catch (e) {
      // 오류 메시지를 출력합니다.
      print('Error signing in with Google: $e');

      // 사용자에게 오류 메시지를 표시합니다.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to sign in with Google: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Sign In Page'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('debug* current user: ${user?.email}'),
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
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {},
                child: const Text('LOG IN'),
              ),
              TextButton(
                onPressed: () {},
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
                  ElevatedButton(
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
                  ElevatedButton(
                    onPressed: () {},
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
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const SignUpPage(),
                        ),
                      );
                    },
                    child: const Text('Sign Up'),
                  ),
                ],
              )
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

// *리버팟을 쓰는 이유:
// 위젯안의 정보를 다른 곳에 연관되어쓸때
// 여러 위젯에 어떻게 넣어줄것인가?
// 정보가 업데이트될때 변화 필요
//
// *리퍼팟만의 특징
//
// DI-필요 정보를 주입한다.
// (의존성 주입:정보를 어떻게 넣어줄것인가?)
// 위젯 자체에서 프로바이더를 만드는 코드가 있다면
// 커플링이 심하게 되었다. - 위젯 테스트코드 작성할때 위젯코드만 테스트 해야하는데
// 위젯안의 프로바이더까지 테스트를 하게 되는 경우가 있다.
//
// 리버팟은 ref로 해결한다.
// ref를 통해서 다른 위젯을 조절한다.
// 프로바이더가 ref를 통해서 전달이 된다.
// 나중에 테스트 코드를 작성할때, ref안에 mock 프로바이더를 넣어서
// 코드들을 분리시킬 수 있다.(커플링을 버퍼)
//
// 또한 여러 프로바이더를 엮을때 유리함.
// (멀티 프로바이더 보다 코드가 간결해짐)
//
// 리버팟으로 해결가능
//
// asyncvalue : 선언형으로 코드를 짤때= 버튼이 어쩔때는 바뀌는거
//
// 네트워크 통해서 받아와야하는경우는 먼저온게 결과 값이 될때까지 기다려야함
// or 로딩중 or 에러날 경우
//
// 로딩중일때는 ref-로 읽고 있을때 비동기라면 가져오는 값이 future ,stream 인데,
// 그런거를 asyncvalue 로 가져오는데 이떄 when 을 걸수 있다.
// 3가지 경우에 관해 간결하게 쓸 수 있다.
//
// 사다리처럼 이론,실습 번갈아서 하기, 하나만 오래끄는 것은 안좋은 공부법
//
//
// 지훈 : 리버팟을 사용하며 구현할지 vs 구현을 어느정도 하고 리버팟을 씌우지
//
// - 제일 좋은것은 stateful 로 하다가 한계를 직접 느껴보는것 -> 그 후에 쓰는방향
// - 일단은 강제로라도 쓰는것을 추천함 (공부하는 차원에서)
//
//
// 국한 : fcm 에서 에러는 안나는데 알림이 안올때
//       적어도 중간과정이라도 알수 있는 방법? : 플러터 코드 안에서
//          **버튼을 하나 만들어서 버튼을 클릭하면 푸쉬가 나 자신에게 오게끔
//
//       fcm 로그를 알 수 있는곳 : 파이어베이스 메세지 보고서
