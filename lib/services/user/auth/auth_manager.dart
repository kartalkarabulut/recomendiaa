// import 'package:firebase_auth/firebase_auth.dart';
import 'package:recomendiaa/models/user_model.dart';
import 'package:recomendiaa/services/user/auth/auth_service_interface.dart';
import 'package:recomendiaa/services/user/data/to-firestore/user_data_to_firestore_imp.dart';

// class AuthManager {
//   final AuthServiceInterface _authService;
//   final UserDataToFirestoreImp _firestoreImp;

//   AuthManager(this._authService, this._firestoreImp);

//   Future<UserModel?> signInAndSaveData(String? email, String? password) async {
//     final UserModel? user = await _authService.signIn(email, password);
//     if (user != null) {
//       await _firestoreImp.saveUserData(user);
//       return user;
//     } else {
//       return null;
//     }
//   }

//   String signUpWithEmailPassword(String email, String password) {
//     print("hello");
//     return "mm";
//   }
// }
