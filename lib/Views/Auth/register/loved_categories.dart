import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recomendiaa/Views/Auth/register/register_view.dart';
import 'package:recomendiaa/Views/HomePage/home_page.dart';
import 'package:recomendiaa/core/constants/category_names.dart';
import 'package:recomendiaa/core/theme/colors/app_colors.dart';
import 'package:recomendiaa/core/theme/colors/gradient_colors.dart';
import 'package:recomendiaa/core/theme/styles/app_text_styles.dart';
import 'package:recomendiaa/models/book_recomendation_model.dart';
import 'package:recomendiaa/models/movie_recomendation_model.dart';
import 'package:recomendiaa/repository/auth_repository.dart';
import 'package:recomendiaa/repository/recomendation_repository.dart';
import 'package:recomendiaa/services/recomendation-generation/book/gemini_book_service.dart';
import 'package:recomendiaa/services/recomendation-history/recomendation_database.dart';
import 'package:recomendiaa/services/user/auth/email_password_signin_imp.dart';
import 'package:recomendiaa/services/user/auth/google_sign_in_imp.dart';
import 'package:recomendiaa/services/user/data/to-firestore/user_data_to_firestore_imp.dart';

class LovedCategoriesState {
  LovedCategoriesState(
      {required this.selectedMovieCategories,
      required this.selectedBookCategories});

  final List<String> selectedBookCategories;
  final List<String> selectedMovieCategories;
}

class LovedCategoriesViewModel extends StateNotifier<LovedCategoriesState> {
  LovedCategoriesViewModel()
      : super(LovedCategoriesState(
            selectedMovieCategories: [], selectedBookCategories: []));

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
}

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

class LovedCategories extends ConsumerWidget {
  const LovedCategories({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final viewModel = ref.watch(lovedCategoriesViewModelProvider.notifier);
    // final state = ref.watch(lovedCategoriesViewModelProvider);
    final bookRecomendationRepository =
        ref.read(bookRecomendationRepositoryProvider);
    final movieRecomendationRepository =
        ref.read(movieRecomendationRepositoryProvider);
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  gradient: AppGradientColors.primaryGradient,
                  // color: AppColors.greenyColor,
                  backgroundBlendMode: BlendMode.lighten),
            ),
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 0),
                child: Container(color: Colors.black.withOpacity(0.75)),
              ),
            ),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text(
                    //   "To be able to recommend you the best content, we need to know your favorite categories",
                    //   style: AppTextStyles.mediumTextStyle,
                    // ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        "Movie Categories",
                        style: AppTextStyles.xLargeTextStyle
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Wrap(
                      spacing: 10,
                      runSpacing: 15,
                      children: CategoryNames.categories
                          .map((category) => CategoryNameBox(
                                title: category,
                                isMovie: true,
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        "Book Categories",
                        style: AppTextStyles.xLargeTextStyle
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Wrap(
                      spacing: 10,
                      runSpacing: 15,
                      children: CategoryNames.bookCategories
                          .map((category) => CategoryNameBox(
                                title: category,
                                isMovie: false,
                              ))
                          .toList(),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: AppColors.yellowGreenColor,
          onPressed: () async {
            final authRepository = ref.read(authRepositoryProvider);
            final registeringUser = ref.read(registeringUserProvider.notifier);
            //!initial recomendation in here

            List<BookRecomendationModel> bookRecomendations =
                await bookRecomendationRepository.initialRecomendation(
                    registeringUser.state.lovedBookCategories, []);
            List<String> bookPrompts = await bookRecomendationRepository
                .initialGeneratePromptSuggestion(
                    null,
                    registeringUser.state.lovedBookCategories,
                    RecomendationType.book);
            print("kitap prompts ${bookPrompts}");
            List<String> moviePrompts = await movieRecomendationRepository
                .initialGeneratePromptSuggestion(
                    null,
                    registeringUser.state.lovedMovieCategories,
                    RecomendationType.movie);
            print("film prompts ${moviePrompts}");
            List<MovieRecomendationModel> movieRecomendations =
                await movieRecomendationRepository.initialRecomendation(
                    registeringUser.state.lovedMovieCategories, []);
            registeringUser.state.lastSuggestedBooks = bookRecomendations;
            registeringUser.state.lastSuggestedMovies = movieRecomendations;
            registeringUser.state.lastSuggestedBookPrompts = bookPrompts;
            registeringUser.state.lastSuggestedMoviePrompts = moviePrompts;

            //!end of initial recomendation

            final user = await authRepository.signUpAndSaveData(
                registeringUser.state,
                registeringUser.state.email,
                registeringUser.state.password,
                registeringUser.state.fullName,
                SignUpType.emailPassword);
            if (user != null) {
              print(
                  "kullanıcı verileri kaydedildi mi ${user.lastSuggestedBooks.first.title}");
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const HomePage()));
            }
            // final registeringUser = ref.watch(registeringUserProvider);
            // print("viewmodel ${state.selectedBookCategories}");
            // print("provider ${registeringUser.lovedBookCategories}");
            // print("viewmodel ${state.selectedMovieCategories}");
            // print("provider ${registeringUser.lovedMovieCategories}");
            // print(registeringUser.fullName);
            // print(registeringUser.email);
            // print(registeringUser.password);
          },
          label: Text(
            "Finish",
            style: AppTextStyles.largeTextStyle.copyWith(color: Colors.black),
          ),
          icon: const Icon(Icons.arrow_forward, color: Colors.black),
        ),
      ),
    );
  }
}

class CategoryNameBox extends ConsumerWidget {
  CategoryNameBox({
    super.key,
    required this.title,
    required this.isMovie,
    // this.isSelected = false,
  });

  final bool isMovie;
  final String title;

  //  bool isSelected;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(lovedCategoriesViewModelProvider.notifier);
    final state = ref.watch(lovedCategoriesViewModelProvider);
    final registeringUser = ref.read(registeringUserProvider.notifier);

    final isSelected = isMovie
        ? state.selectedMovieCategories.contains(title)
        : state.selectedBookCategories.contains(title);
    return GestureDetector(
      onTap: () {
        if (isSelected) {
          if (isMovie) {
            viewModel.removeMovieCategory(title);
            registeringUser.state.lovedMovieCategories.remove(title);
          } else {
            viewModel.removeBookCategory(title);
            registeringUser.state.lovedBookCategories.remove(title);
          }
        } else {
          if (isMovie) {
            registeringUser.state.lovedMovieCategories.add(title);
            viewModel.addMovieCategory(title);
          } else {
            viewModel.addBookCategory(title);
            registeringUser.state.lovedBookCategories.add(title);
          }
        }
      },
      child: Container(
        padding: const EdgeInsets.all(10),

        // width: 100,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.greenyColor : AppColors.greenColor,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          title,
          style: isSelected
              ? AppTextStyles.largeTextStyle
                  .copyWith(color: AppColors.primary100)
              : AppTextStyles.largeTextStyle,
        ),
      ),
    );
  }
}
