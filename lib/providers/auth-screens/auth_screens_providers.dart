import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recomendiaa/Views/Auth/login/login_view_model.dart';
import 'package:recomendiaa/Views/Auth/register/category-selection/category_selection_viewmodel.dart';
// import 'package:recomendiaa/Views/Auth/register/loved_categories.dart';
// import 'package:recomendiaa/Views/Auth/register/loved_categories.dart';
import 'package:recomendiaa/repository/auth_repository.dart';
import 'package:recomendiaa/services/user/auth/email_password_signin_imp.dart';
import 'package:recomendiaa/services/user/auth/google_sign_in_imp.dart';
import 'package:recomendiaa/services/user/data/to-firestore/user_data_to_firestore_imp.dart';

final loginViewModelProvider =
    StateNotifierProvider<LoginViewModel, LoginState>((ref) {
  return LoginViewModel();
});

final lovedCategoriesViewModelProvider =
    StateNotifierProvider<LovedCategoriesViewModel, LovedCategoriesState>(
        (ref) {
  return LovedCategoriesViewModel();
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
      emailPasswordAuthService: EmailPasswordSigninImp(),
      firestoreImp: UserDataToFirestoreImp(),
      googleAuthService: GoogleSignInImp());
});
