import 'package:firebase_auth/firebase_auth.dart';
import 'package:recomendiaa/models/user_model.dart';
import 'package:recomendiaa/services/user/auth/auth_service_interface.dart';
import 'package:recomendiaa/services/user/data/to-firestore/user_data_to_firestore_imp.dart';

enum SignUpType {
  emailPassword,
  google,
}

class AuthRepository {
  AuthRepository(
      {required this.emailPasswordAuthService,
      required this.googleAuthService,
      required this.firestoreImp});

  final AuthServiceInterface emailPasswordAuthService;
  final UserDataToFirestoreImp firestoreImp;
  final AuthServiceInterface googleAuthService;

  Future<UserModel?> signUpAndSaveData(UserModel? user, String? email,
      String? password, String fullName, SignUpType signUpType) async {
    UserCredential? userCredential;
    if (signUpType == SignUpType.emailPassword) {
      userCredential = await emailPasswordAuthService.signUp(email, password);
    }
    if (userCredential != null) {
      await firestoreImp
          .saveUserData(user!.copyWith(id: userCredential.user!.uid));

      return user;
    } else {
      return null;
    }
  }

  Future<bool> signInWithEmailPassword(String email, String password) async {
    return await emailPasswordAuthService.signIn(email, password);
  }
}
