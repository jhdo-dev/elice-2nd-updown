import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:up_down/util/helper/firebase_helper.dart';
import 'package:up_down/util/helper/handle_exception.dart';

class AuthRepository {
  User? get currentUser => fbAuth.currentUser;
  final googleSignIn = GoogleSignIn();

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

  Future<void> signInWithGoogle() async {
    try {
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        throw Exception('Google sign in aborted');
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final newUser = await fbAuth.signInWithCredential(credential);

      await usersCollection.doc(newUser.user!.uid).set({
        'name': newUser.user!.displayName,
        'email': newUser.user!.email,
        // 'photo': photo.url,
        'isAdmin': false,
      });
    } catch (e) {
      print('google error: $e');
      throw handleException(e);
    }
  }

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

  Future<void> changeName(String newName) async {
    try {
      await currentUser!.updateProfile(displayName: newName);
      await currentUser!.reload();

      // Firestore에서 사용자 이름 업데이트
      await usersCollection.doc(currentUser!.uid).update({
        'name': newName,
      });
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

// Future<void> sendEmailVerification() async {
//   try {
//     await currentUser!.sendEmailVerification();
//   } catch (e) {
//     throw handleException(e);
//   }
// }

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

  Future<void> deleteAccount() async {
    try {
      await usersCollection.doc(currentUser!.uid).delete();
      await currentUser!.delete();
    } catch (e) {
      throw handleException(e);
    }
  }
}
