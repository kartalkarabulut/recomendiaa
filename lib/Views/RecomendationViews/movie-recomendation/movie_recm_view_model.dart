import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recomendiaa/SharedViews/buttons/custom_button.dart';
import 'package:recomendiaa/models/movie_recomendation_model.dart';
import 'package:recomendiaa/providers/movie_related_providers.dart';
import 'package:recomendiaa/providers/user_data_providers.dart';
import 'package:recomendiaa/repository/recomendation_repository.dart';
import 'package:recomendiaa/services/recomendation-history/recomendation_database.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MovieRecomendationViewModel extends StateNotifier {
  MovieRecomendationViewModel() : super(null);

  Future<void> generateMovieSuggestion(WidgetRef ref, String language) async {
    // Get user data from provider
    final userData = ref.watch(userDataProvider);

    // Get movie recommendation repository
    final movieRecomendationRepository =
        ref.read(movieRecomendationRepositoryProvider);

    // Generate movie suggestions based on user's prompt history and loved categories
    List<MovieRecomendationModel> movieValue =
        await movieRecomendationRepository.recomendationGenerationService
            .generateSuggestion(
      userData.value?.moviePromptHistory ?? [],
      userData.value?.lovedMovieCategories ?? [],
      language,
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
  Future<void> handleRecomendationGeneration(
      BuildContext context,
      WidgetRef ref,
      TextEditingController promptController,
      String language) async {
    if (promptController.text.isEmpty) return;

    // Mevcut önerileri temizle
    ref.read(generatedMovieRecommendationsProvider.notifier).state = [];
    ref.read(isButtonWorkignProvider.notifier).state = true;
    final movieRepository = ref.read(movieRecomendationRepository);

    try {
      final recomendations = await movieRepository.makeRecomendation(
          promptController.text, language, RecomendationType.movie);

      if (context.mounted && recomendations.isNotEmpty) {
        generateMovieSuggestion(ref, language);

        movieRepository
            .generatePromptSuggestion(
                ref.read(userDataProvider).value?.lastSuggestedMoviePrompts,
                ref.read(userDataProvider).value?.lovedMovieCategories,
                language,
                RecomendationType.movie)
            .then((value) {
          ref.invalidate(userDataProvider);
        });

        ref.read(generatedMovieRecommendationsProvider.notifier).state =
            recomendations as List<MovieRecomendationModel>;
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(AppLocalizations.of(context)!
                    .recommendationGenerationFailed)),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(AppLocalizations.of(context)!.error(e.toString()))),
        );
      }
    } finally {
      ref.read(isButtonWorkignProvider.notifier).state = false;
    }
  }
}
