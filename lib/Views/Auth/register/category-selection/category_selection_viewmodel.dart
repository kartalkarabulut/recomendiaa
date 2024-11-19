import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recomendiaa/SharedViews/shared_snackbars.dart';
import 'package:recomendiaa/Views/Auth/register/register_view.dart';
import 'package:recomendiaa/Views/Home/home_page.dart';
import 'package:recomendiaa/models/book_recomendation_model.dart';
import 'package:recomendiaa/models/movie_recomendation_model.dart';
import 'package:recomendiaa/models/user_model.dart';
import 'package:recomendiaa/providers/auth-screens/auth_screens_providers.dart';
import 'package:recomendiaa/repository/auth_repository.dart';
import 'package:recomendiaa/repository/recomendation_repository.dart';
import 'package:recomendiaa/services/recomendation-history/recomendation_database.dart';

class LovedCategoriesState {
  LovedCategoriesState(
      {required this.selectedMovieCategories,
      required this.selectedBookCategories,
      this.isLoading = false});

  final List<String> selectedBookCategories;
  final List<String> selectedMovieCategories;
  bool isLoading;
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
      BuildContext context, WidgetRef ref) async {
    final authRepository = ref.read(authRepositoryProvider);
    final registeringUser = ref.read(registeringUserProvider.notifier);
    final bookRecomendationRepository =
        ref.read(bookRecomendationRepositoryProvider);
    final movieRecomendationRepository =
        ref.read(movieRecomendationRepositoryProvider);

    try {
      state = LovedCategoriesState(
          selectedMovieCategories: state.selectedMovieCategories,
          selectedBookCategories: state.selectedBookCategories,
          isLoading: true);
      //!Initial movie recomendations
      List<MovieRecomendationModel> movieRecomendations =
          await movieRecomendationRepository.initialRecomendation(
              registeringUser.state.lovedMovieCategories, []);
      print("movie recomendations ${movieRecomendations}");
      //!Initial movie prompt recomendations
      List<String> moviePrompts =
          await movieRecomendationRepository.initialGeneratePromptSuggestion(
              null,
              registeringUser.state.lovedMovieCategories,
              RecomendationType.movie);
      print("film prompts ${moviePrompts}");
      //!Iinital book recomendations
      List<BookRecomendationModel> bookRecomendations =
          await bookRecomendationRepository.initialRecomendation(
              registeringUser.state.lovedBookCategories, []);

      //!Initial book prompts recomendations
      List<String> bookPrompts =
          await bookRecomendationRepository.initialGeneratePromptSuggestion(
              null,
              registeringUser.state.lovedBookCategories,
              RecomendationType.book);
      print("kitap prompts ${bookPrompts}");

      //!Setting last suggested books, movies, book prompts and movie prompts
      registeringUser.state.lastSuggestedBooks = bookRecomendations;
      registeringUser.state.lastSuggestedMovies = movieRecomendations;
      registeringUser.state.lastSuggestedBookPrompts = bookPrompts;
      registeringUser.state.lastSuggestedMoviePrompts = moviePrompts;

      //!Signing up and saving data to firestore
      UserModel? user = await authRepository.signUpAndSaveData(
          registeringUser.state,
          registeringUser.state.email,
          registeringUser.state.password,
          registeringUser.state.fullName,
          SignUpType.emailPassword);
      state = LovedCategoriesState(
          selectedMovieCategories: state.selectedMovieCategories,
          selectedBookCategories: state.selectedBookCategories,
          isLoading: false);
      return user;
    } catch (e) {
      state = LovedCategoriesState(
          selectedMovieCategories: state.selectedMovieCategories,
          selectedBookCategories: state.selectedBookCategories,
          isLoading: false);
      SharedSnackbars.showErrorSnackBar(context, "Something went wrong");
      return null;
    }
  }
}
