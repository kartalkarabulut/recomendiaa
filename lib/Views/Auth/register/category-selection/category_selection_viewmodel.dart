import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recomendiaa/SharedViews/shared_snackbars.dart';
import 'package:recomendiaa/Views/Auth/register/register_view.dart';
import 'package:recomendiaa/Views/Home/home_page.dart';
import 'package:recomendiaa/models/book_recomendation_model.dart';
import 'package:recomendiaa/models/movie_recomendation_model.dart';
import 'package:recomendiaa/models/user_model.dart';
import 'package:recomendiaa/providers/auth-screens/auth_screens_providers.dart';
import 'package:recomendiaa/providers/user_data_providers.dart';
import 'package:recomendiaa/repository/auth_repository.dart';
import 'package:recomendiaa/repository/recomendation_repository.dart';
import 'package:recomendiaa/services/recomendation-history/recomendation_database.dart';

class LovedCategoriesState {
  LovedCategoriesState({
    required this.selectedMovieCategories,
    required this.selectedBookCategories,
    this.isLoading = false,
    this.registrationStatus = '', // Yeni alan
  });

  final List<String> selectedBookCategories;
  final List<String> selectedMovieCategories;
  bool isLoading;
  String registrationStatus; // Yeni alan
}

class LovedCategoriesViewModel extends StateNotifier<LovedCategoriesState> {
  LovedCategoriesViewModel()
      : super(LovedCategoriesState(
            selectedMovieCategories: [],
            selectedBookCategories: [],
            isLoading: false));

  void addBookCategory(String bookCategoryName) {
    state = LovedCategoriesState(
      selectedMovieCategories: state.selectedMovieCategories,
      selectedBookCategories: [
        ...state.selectedBookCategories,
        bookCategoryName
      ],
    );
  }

  void addMovieCategory(String movieCategoryName) {
    state = LovedCategoriesState(
      selectedMovieCategories: [
        ...state.selectedMovieCategories,
        movieCategoryName
      ],
      selectedBookCategories: state.selectedBookCategories,
    );
  }

  void removeBookCategory(String bookCategoryName) {
    state = LovedCategoriesState(
      selectedMovieCategories: state.selectedMovieCategories,
      selectedBookCategories: state.selectedBookCategories
          .where((category) => category != bookCategoryName)
          .toList(),
    );
  }

  void removeMovieCategory(String movieCategoryName) {
    state = LovedCategoriesState(
      selectedMovieCategories: state.selectedMovieCategories
          .where((category) => category != movieCategoryName)
          .toList(),
      selectedBookCategories: state.selectedBookCategories,
    );
  }

  Future<UserModel?> finishRegistration(
      BuildContext context, WidgetRef ref, String language) async {
    final authRepository = ref.read(authRepositoryProvider);
    final registeringUser = ref.read(registeringUserProvider.notifier);
    final bookRecomendationRepository =
        ref.read(bookRecomendationRepositoryProvider);
    final movieRecomendationRepository =
        ref.read(movieRecomendationRepositoryProvider);

    try {
      _updateState(isLoading: true, status: 'Initializing...');

      // Film önerileri
      _updateState(status: 'Preparing movie recommendations...');
      List<MovieRecomendationModel> movieRecomendations =
          await movieRecomendationRepository.initialRecomendation(
              registeringUser.state.lovedMovieCategories, [], language);

      // Film promptları
      _updateState(status: 'Creating prompts for movie recommendations...');
      List<String> moviePrompts =
          await movieRecomendationRepository.initialGeneratePromptSuggestion(
              null,
              registeringUser.state.lovedMovieCategories,
              language,
              RecomendationType.movie);

      // Kitap önerileri
      _updateState(status: 'Preparing book recommendations...');
      List<BookRecomendationModel> bookRecomendations =
          await bookRecomendationRepository.initialRecomendation(
              registeringUser.state.lovedBookCategories, [], language);

      // Kitap promptları
      _updateState(status: 'Creating prompts for book recommendations...');
      List<String> bookPrompts =
          await bookRecomendationRepository.initialGeneratePromptSuggestion(
              null,
              registeringUser.state.lovedBookCategories,
              language,
              RecomendationType.book);

      // Kullanıcı verilerini güncelleme
      _updateState(status: 'Saving recommendations...');
      registeringUser.state.lastSuggestedBooks = bookRecomendations;
      registeringUser.state.lastSuggestedMovies = movieRecomendations;
      registeringUser.state.lastSuggestedBookPrompts = bookPrompts;
      registeringUser.state.lastSuggestedMoviePrompts = moviePrompts;

      // Kullanıcı kaydı
      _updateState(status: 'Creating your account...');
      UserModel? user = await authRepository.signUpAndSaveData(
          registeringUser.state,
          registeringUser.state.email,
          registeringUser.state.password,
          registeringUser.state.fullName,
          SignUpType.emailPassword);

      if (user != null) {
        ref.invalidate(registeringUserProvider);
        ref.invalidate(userDataProvider);
        ref.invalidate(authStateProvider);
        _updateState(status: 'Registration successful! Redirecting...');
        await Future.delayed(const Duration(
            seconds: 1)); // Başarı mesajının görünmesi için kısa bekletme
        return user;
      } else {
        _updateState(isLoading: false, status: '');
        SharedSnackbars.showErrorSnackBar(context, "Registration failed");
        return null;
      }
    } catch (e) {
      print("Registration error: $e");
      _updateState(isLoading: false, status: '');
      SharedSnackbars.showErrorSnackBar(
          context, "Unexpected error. Please try again.");
      return null;
    } finally {
      _updateState(isLoading: false, status: '');
    }
  }

// State güncelleme yardımcı metodu
  void _updateState({bool? isLoading, String? status}) {
    state = LovedCategoriesState(
      selectedMovieCategories: state.selectedMovieCategories,
      selectedBookCategories: state.selectedBookCategories,
      isLoading: isLoading ?? state.isLoading,
      registrationStatus: status ?? state.registrationStatus,
    );
  }
}
