import 'package:firebase_auth/firebase_auth.dart';
import 'package:recomendiaa/models/user_model.dart';
import 'package:recomendiaa/services/user/auth/auth_service_interface.dart';

class EmailPasswordSigninImp implements AuthServiceInterface {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Future<bool> signIn(String? email, String? password) async {
    try {
      final UserCredential? userCredential =
          await _auth.signInWithEmailAndPassword(
        email: email!,
        password: password!,
      );
      // return userCredential.user;
      if (userCredential != null) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Email/Password Sign-In Error: $e');
      return false;
    }
  }

  @override
  Future<UserCredential?> signUp(String? email, String? password) async {
    try {
      final UserCredential? userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email!,
        password: password!,
      );
      if (userCredential != null) {
        return userCredential;
      } else {
        return null;
      }
    } catch (e) {
      print('Email/Password Sign-Up Error: $e');
      return null;
    }
  }
}
