import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recomendiaa/Views/Auth/register/register_view.dart';
import 'package:recomendiaa/Views/Home/home_page.dart';
import 'package:recomendiaa/app/page_rooter_widget.dart';
// import 'package:recomendiaa/Views/Auth/register/register_view.dart';
import 'package:recomendiaa/core/constants/category_names.dart';
import 'package:recomendiaa/core/theme/colors/app_colors.dart';
import 'package:recomendiaa/core/theme/colors/gradient_colors.dart';
import 'package:recomendiaa/core/theme/styles/app_text_styles.dart';
import 'package:recomendiaa/models/book_recomendation_model.dart';
import 'package:recomendiaa/models/movie_recomendation_model.dart';
import 'package:recomendiaa/providers/auth-screens/auth_screens_providers.dart';
import 'package:recomendiaa/providers/user_data_providers.dart';
import 'package:recomendiaa/repository/auth_repository.dart';
import 'package:recomendiaa/repository/recomendation_repository.dart';
import 'package:recomendiaa/services/recomendation-history/recomendation_database.dart';
// import 'package:recomendiaa/providers/auth-screens/auth_screens_providers.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LovedCategories extends ConsumerWidget {
  const LovedCategories({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final viewModel = ref.watch(lovedCategoriesViewModelProvider.notifier);
    final state = ref.watch(lovedCategoriesViewModelProvider);

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: AppGradientColors.primaryGradient,
                backgroundBlendMode: BlendMode.lighten,
              ),
            ),
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 0),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.6),
                        Colors.black.withOpacity(0.8),
                      ],
                    ),
                  ),
                ),
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
                      child: Row(
                        children: [
                          Text(
                            "Movie Categories",
                            style: AppTextStyles.xLargeTextStyle
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 10),
                          IconButton(
                              iconSize: 20,
                              onPressed: () {},
                              icon: Image.asset(
                                "assets/images/categories.png",
                                width: 30,
                                color: Colors.orange,
                              ))
                        ],
                      ),
                    ),
                    Wrap(
                      spacing: 10,
                      runSpacing: 15,
                      children: CategoryNames.categories
                          .map((category) => CategoryNameBox(
                                title: category,
                                isMovie: true,
                                recomendationType: RecomendationType.movie,
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: [
                          Text(
                            "Book Categories",
                            style: AppTextStyles.xLargeTextStyle
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 10),
                          IconButton(
                              iconSize: 20,
                              onPressed: () {},
                              icon: Image.asset(
                                "assets/images/categories.png",
                                width: 30,
                                color: Colors.teal,
                              ))
                        ],
                      ),
                    ),
                    Wrap(
                      spacing: 10,
                      runSpacing: 15,
                      children: CategoryNames.bookCategories
                          .map((category) => CategoryNameBox(
                                title: category,
                                isMovie: false,
                                recomendationType: RecomendationType.book,
                              ))
                          .toList(),
                    )
                  ],
                ),
              ),
            ),
            if (state.isLoading == true)
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                  ),
                  child: Center(
                    child: Container(
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2C3E50),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 10,
                            spreadRadius: 5,
                          )
                        ],
                      ),
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 20),
                          decoration: BoxDecoration(
                            color: Color(0xFF2C3E50),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.orange),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                state.registrationStatus,
                                style: AppTextStyles.mediumTextStyle
                                    .copyWith(color: Colors.white),
                                textAlign: TextAlign.center,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
        floatingActionButton: Opacity(
          opacity: state.isLoading ? 0.5 : 1,
          child: FloatingActionButton.extended(
            backgroundColor: AppColors.yellowGreenColor,
            onPressed: () async {
              print("fab pressed  eaee e fffff aaaaaaaa bbbb ccccccc");
              final language = Localizations.localeOf(context).languageCode;
              final viewModel =
                  ref.read(lovedCategoriesViewModelProvider.notifier);
              final user =
                  await viewModel.finishRegistration(context, ref, language);
              if (user != null) {
                ref.invalidate(userIdProvider);
                ref.invalidate(userDataProvider);

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PageRooter(),
                  ),
                );
              }
              // final authRepository = ref.read(authRepositoryProvider);
              // final registeringUser = ref.read(registeringUserProvider.notifier);
              // //!initial recomendation in here
              // final bookRecomendationRepository =
              //     ref.read(bookRecomendationRepositoryProvider);
              // final movieRecomendationRepository =
              //     ref.read(movieRecomendationRepositoryProvider);

              // List<String> moviePrompts = await movieRecomendationRepository
              //     .initialGeneratePromptSuggestion(
              //         null,
              //         registeringUser.state.lovedMovieCategories,
              //         RecomendationType.movie);
              // print("film prompts ${moviePrompts}");
              // List<MovieRecomendationModel> movieRecomendations =
              //     await movieRecomendationRepository.initialRecomendation(
              //         registeringUser.state.lovedMovieCategories, []);

              // List<BookRecomendationModel> bookRecomendations =
              //     await bookRecomendationRepository.initialRecomendation(
              //         registeringUser.state.lovedBookCategories, []);
              // List<String> bookPrompts = await bookRecomendationRepository
              //     .initialGeneratePromptSuggestion(
              //         null,
              //         registeringUser.state.lovedBookCategories,
              //         RecomendationType.book);
              // print("kitap prompts ${bookPrompts}");

              // registeringUser.state.lastSuggestedBooks = bookRecomendations;
              // registeringUser.state.lastSuggestedMovies = movieRecomendations;
              // registeringUser.state.lastSuggestedBookPrompts = bookPrompts;
              // registeringUser.state.lastSuggestedMoviePrompts = moviePrompts;

              // //!end of initial recomendation

              // final user = await authRepository.signUpAndSaveData(
              //     registeringUser.state,
              //     registeringUser.state.email,
              //     registeringUser.state.password,
              //     registeringUser.state.fullName,
              //     SignUpType.emailPassword);
              // if (user != null) {
              //   print(
              //       "kullanıcı verileri kaydedildi mi ${user.lastSuggestedBooks.first.title}");
              //   Navigator.pushReplacement(context,
              //       MaterialPageRoute(builder: (context) => const HomePage()));
              // }
            },
            label: Text(
              "Finish",
              style: AppTextStyles.largeTextStyle.copyWith(color: Colors.black),
            ),
            icon: const Icon(Icons.arrow_forward, color: Colors.black),
          ),
        ),
      ),
    );
  }
}

class CategoryNameBox extends ConsumerWidget {
  const CategoryNameBox({
    super.key,
    required this.title,
    required this.isMovie,
    required this.recomendationType,
  });

  final bool isMovie;
  final RecomendationType recomendationType;
  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(lovedCategoriesViewModelProvider.notifier);
    final state = ref.watch(lovedCategoriesViewModelProvider);
    final registeringUser = ref.read(registeringUserProvider.notifier);

    final isSelected = isMovie
        ? state.selectedMovieCategories.contains(title)
        : state.selectedBookCategories.contains(title);

    final color = recomendationType == RecomendationType.movie
        ? Colors.orange
        : Colors.teal;

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
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isSelected ? color.withOpacity(0.5) : color,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              title,
              style: AppTextStyles.largeTextStyle.copyWith(color: Colors.black),
            ),
          ),
          if (isSelected)
            Positioned(
              right: -5,
              top: -5,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle,
                  color: color,
                  size: 20,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
