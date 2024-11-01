import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:recomendiaa/models/user_model.dart';
import 'package:recomendiaa/services/user/auth/auth_service_interface.dart';

class GoogleSignInImp implements AuthServiceInterface {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Future<UserModel?> signIn(String? email, String? password) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential? userCredential =
          await _auth.signInWithCredential(credential);
      // return userCredential.user;
      if (userCredential != null) {
        return UserModel(
            id: userCredential.user!.uid,
            fullName: userCredential.user!.displayName!,
            email: userCredential.user!.email!,
            password: "",
            lovedMovieCategories: [],
            lovedBookCategories: [],
            bookPromptHistory: [],
            moviePromptHistory: [],
            savedMovies: [],
            savedBooks: [],
            lastSuggestedMoviePrompts: [],
            lastSuggestedMovies: [],
            lastSuggestedBookPrompts: [],
            lastSuggestedBooks: []);
      } else {
        return null;
      }
    } catch (e) {
      print('Google Sign-In Error: $e');
      return null;
    }
  }

  @override
  Future<UserModel?> signUp(String? email, String? password) async {
    return await signIn(email, password);
  }
}
