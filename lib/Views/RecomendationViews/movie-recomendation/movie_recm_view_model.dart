import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recomendiaa/Views/Auth/login/login_view.dart';
import 'package:recomendiaa/Views/RecomendationViews/movie-recomendation/widgets/movie_recm_sheet.dart';
import 'package:recomendiaa/core/constants/app_constans.dart';
import 'package:recomendiaa/core/theme/colors/app_colors.dart';
import 'package:recomendiaa/models/movie_recomendation_model.dart';
import 'package:recomendiaa/providers/user_data_providers.dart';
import 'package:recomendiaa/repository/recomendation_repository.dart';
import 'package:recomendiaa/services/recomendation-history/recomendation_database.dart';

final movieRecomendationViewModelProvider =
    StateNotifierProvider<MovieRecomendationViewModel, void>((ref) {
  return MovieRecomendationViewModel();
});

class MovieRecomendationViewModel extends StateNotifier {
  MovieRecomendationViewModel() : super(null);

  Future<void> generateMovieSuggestion(WidgetRef ref) async {
    // Get user data from provider
    final userData = ref.watch(userDataProvider);

    // Get movie recommendation repository
    final movieRecomendationRepository =
        ref.read(movieRecomendationRepositoryProvider);

    // print(userData.value!.moviePromptHistory.toString());
    // print(userData.value!.lovedMovieCategories.toString());

    // Generate movie suggestions based on user's prompt history and loved categories
    List<MovieRecomendationModel> movieValue =
        await movieRecomendationRepository.recomendationGenerationService
            .generateSuggestion(
      userData.value?.moviePromptHistory ?? [],
      userData.value?.lovedMovieCategories ?? [],
    ) as List<MovieRecomendationModel>;

    // Convert movie models to JSON format
    final List<Map<String, dynamic>> movieMaps =
        movieValue.map((movie) => movie.toJson()).toList();

    // Save generated suggestions to Firestore
    movieRecomendationRepository.userDataToFirestore
        .saveSuggestedRecomendations(movieMaps, RecomendationType.movie);
    ref.invalidate(userDataProvider);
  }

  //!Handle recomendation generation
  Future<void> handleRecomendationGeneration(BuildContext context,
      WidgetRef ref, TextEditingController promptController) async {
    // Return if prompt is empty
    if (promptController.text.isEmpty) return;

    // Set button loading state
    ref.read(isButtonWorkignProvider.notifier).state = true;
    final movieRepository = ref.read(movieRecomendationRepository);

    try {
      // Generate recommendations based on user prompt
      final recomendations = await movieRepository.makeRecomendation(
          promptController.text, RecomendationType.movie);

      if (context.mounted) {
        if (recomendations.isNotEmpty) {
          // Generate new movie suggestions if recommendations exist
          generateMovieSuggestion(ref);

          // Generate new prompt suggestions for future use
          movieRepository
              .generatePromptSuggestion(
                  ref.read(userDataProvider).value?.lastSuggestedMoviePrompts,
                  ref.read(userDataProvider).value?.lovedMovieCategories,
                  RecomendationType.movie)
              .then(
            (value) {
              print("will invalidate");
              ref.invalidate(userDataProvider);
            },
          );

          // Display recommendations in bottom sheet
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: AppColors.yellowGreenColor.withOpacity(0.5),
            constraints: BoxConstraints(
              maxHeight: AppConstants.screenHeight(context) * 0.7,
            ),
            builder: (context) => MovieRecmSheet(
                recomendations:
                    recomendations as List<MovieRecomendationModel>),
          );
        } else {
          // Show error if no recommendations generated
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Öneri oluşturulamadı. Lütfen tekrar deneyin.')),
          );
        }
        ref.read(isButtonWorkignProvider.notifier).state = false;
      }
    } catch (e) {
      // Handle errors and display error message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Bir hata oluştu: $e')),
        );
      }
    } finally {
      // Reset button loading state
      ref.read(isButtonWorkignProvider.notifier).state = false;
    }
  }
}
