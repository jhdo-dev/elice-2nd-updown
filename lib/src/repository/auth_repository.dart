import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:up_down/util/helper/firebase_helper.dart';
import 'package:up_down/util/helper/handle_exception.dart';

class AuthRepository {
  User? get currentUser => fbAuth.currentUser;

  ///Auth
  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await fbAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final signedInUser = userCredential.user!;

      await usersCollection.doc(signedInUser.uid).set({
        'name': name,
        'email': email,
        // 'photo': photo.url,
        'isAdmin': false,
      });
    } catch (e) {
      throw handleException(e);
    }
  }

  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      await fbAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw handleException(e);
    }
  }

  // Future<void> signInWithGoogle() async {
  //   try {
  //     final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

  //     if (googleUser == null) {
  //       return;
  //     }

  //     final GoogleSignInAuthentication googleAuth =
  //         await googleUser.authentication;

  //     final credential = GoogleAuthProvider.credential(
  //       accessToken: googleAuth.accessToken,
  //       idToken: googleAuth.idToken,
  //     );
  //     final newUser = await _auth.signInWithCredential(credential);

  //     await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(newUser.user!.uid)
  //         .set({
  //       'name': newUser.user!.displayName,
  //       'email': newUser.user!.email,
  //       // 'photo': photo.url,
  //       'isAdmin': false,
  //     });

  //     context.go('/home');
  //   } catch (e) {
  //     print('Error signing in with Google: $e');

  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Failed to sign in with Google: $e')),
  //     );
  //   }
  // }

  Future<void> signout() async {
    try {
      await fbAuth.signOut();
    } catch (e) {
      throw handleException(e);
    }
  }

  Future<void> changePassword(String password) async {
    try {
      await currentUser!.updatePassword(password);
    } catch (e) {
      throw handleException(e);
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await fbAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw handleException(e);
    }
  }

  Future<void> sendEmailVerification() async {
    try {
      await currentUser!.sendEmailVerification();
    } catch (e) {
      throw handleException(e);
    }
  }

  Future<void> reloadUser() async {
    try {
      await currentUser!.reload();
    } catch (e) {
      throw handleException(e);
    }
  }

  Future<void> reauthenticateWithCredential(
    String email,
    String password,
  ) async {
    try {
      await currentUser!.reauthenticateWithCredential(
        EmailAuthProvider.credential(email: email, password: password),
      );
    } catch (e) {
      throw handleException(e);
    }
  }
}
