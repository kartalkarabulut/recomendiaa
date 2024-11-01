import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recomendiaa/repository/auth_repository.dart';
import 'package:recomendiaa/services/user/auth/email_password_signin_imp.dart';
import 'package:recomendiaa/services/user/auth/google_sign_in_imp.dart';
import 'package:recomendiaa/services/user/data/to-firestore/user_data_to_firestore_imp.dart';

class LoginState {
  final bool isLoading;
  final String? error;

  LoginState({this.isLoading = false, this.error});

  LoginState copyWith({bool? isLoading, String? error}) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class LoginViewModel extends StateNotifier<LoginState> {
  LoginViewModel() : super(LoginState());
  AuthRepository authRepository = AuthRepository(
      emailPasswordAuthService: EmailPasswordSigninImp(),
      googleAuthService: GoogleSignInImp(),
      firestoreImp: UserDataToFirestoreImp());

  // Future<void> login(String email, String password) async {
  //   state = state.copyWith(isLoading: true);
  //   final user = await authRepository.authService.signIn(email, password);
  //   state = state.copyWith(isLoading: false);
  // }
}
