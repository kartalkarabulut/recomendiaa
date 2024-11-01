import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recomendiaa/models/user_model.dart';
import 'package:recomendiaa/repository/auth_repository.dart';
import 'package:recomendiaa/services/user/auth/email_password_signin_imp.dart';
import 'package:recomendiaa/services/user/auth/google_sign_in_imp.dart';
import 'package:recomendiaa/services/user/data/to-firestore/user_data_to_firestore_imp.dart';

class RegistrationState {
  RegistrationState({
    required this.isLoading,
  });

  final bool isLoading;

  RegistrationState copyWith({
    bool? isLoading,
  }) {
    return RegistrationState(
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class RegistrationViewModel extends StateNotifier<RegistrationState> {
  RegistrationViewModel({required this.authRepository})
      : super(RegistrationState(isLoading: false));

  final AuthRepository authRepository;

  Future<UserModel?> signUp(String email, String password, String fullName,
      SignUpType signUpType) async {
    state = state.copyWith(isLoading: true);
    final user = await authRepository.signUpAndSaveData(
        null, email, password, fullName, signUpType);

    state = state.copyWith(isLoading: false);
    return user;
  }
}

final registrationViewModelProvider =
    StateNotifierProvider<RegistrationViewModel, RegistrationState>((ref) {
  return RegistrationViewModel(
    authRepository: AuthRepository(
      emailPasswordAuthService: EmailPasswordSigninImp(),
      googleAuthService: GoogleSignInImp(),
      firestoreImp: UserDataToFirestoreImp(),
    ),
  );
});
