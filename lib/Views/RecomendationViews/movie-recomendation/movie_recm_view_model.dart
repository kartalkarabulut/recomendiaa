import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recomendiaa/Views/Auth/login/login_view.dart';
import 'package:recomendiaa/Views/RecomendationViews/movie-recomendation/movie_recomendation_view.dart';
import 'package:recomendiaa/Views/RecomendationViews/movie-recomendation/widgets/movie_recm_sheet.dart';
import 'package:recomendiaa/core/constants/app_constans.dart';
import 'package:recomendiaa/core/theme/colors/app_colors.dart';
import 'package:recomendiaa/core/theme/styles/app_text_styles.dart';
import 'package:recomendiaa/models/movie_recomendation_model.dart';
import 'package:recomendiaa/providers/user_data_providers.dart';
import 'package:recomendiaa/repository/recomendation_repository.dart';
import 'package:recomendiaa/services/recomendation-generation/movie/movie_recm_gen_imp.dart';
import 'package:recomendiaa/services/recomendation-history/movie_recm_data_imp.dart';
import 'package:recomendiaa/services/recomendation-history/recomendation_database.dart';
import 'package:recomendiaa/services/user/data/to-firestore/user_data_to_firestore_imp.dart';

final movieRecomendationViewModelProvider =
    StateNotifierProvider<MovieRecomendationViewModel, void>((ref) {
  return MovieRecomendationViewModel();
});

class MovieRecomendationViewModel extends StateNotifier {
  MovieRecomendationViewModel() : super(null);

  Future<void> generateMovieSuggestion(WidgetRef ref) async {
    final userData = ref.watch(userDataProvider);
    print(userData.value!.moviePromptHistory.toString());
    print(userData.value!.lovedMovieCategories.toString());

    RecomendationRepository movieRecomendationRepository =
        RecomendationRepository(
            recomendationGenerationService: GenerateMovieRecomendation(),
            recomendationDatabase: MovieRecomendationDataImp(),
            userDataToFirestore: UserDataToFirestoreImp());

    List<MovieRecomendationModel> movieValue =
        await movieRecomendationRepository.recomendationGenerationService
            .generateSuggestion(
      userData.value?.moviePromptHistory ?? [],
      userData.value?.lovedMovieCategories ?? [],
    ) as List<MovieRecomendationModel>;

    final List<Map<String, dynamic>> movieMaps =
        movieValue.map((movie) => movie.toJson()).toList();

    movieRecomendationRepository.userDataToFirestore
        .saveSuggestedRecomendations(movieMaps, RecomendationType.movie);
  }

  Future<void> handleRecomendationGeneration(BuildContext context,
      WidgetRef ref, TextEditingController promptController) async {
    if (promptController.text.isEmpty) return;

    ref.read(isButtonWorkignProvider.notifier).state = true;
    final movieRepository = ref.read(movieRecomendationRepository);

    try {
      final recomendations = await movieRepository.makeRecomendation(
          promptController.text, RecomendationType.movie);

      if (context.mounted) {
        if (recomendations.isNotEmpty) {
          movieRepository
              .generatePromptSuggestion(
                  ref.read(userDataProvider).value?.lastSuggestedMoviePrompts,
                  ref.read(userDataProvider).value?.lovedMovieCategories,
                  RecomendationType.movie)
              .then(
            (value) {
              ref.invalidate(userDataProvider);
            },
          );
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
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Öneri oluşturulamadı. Lütfen tekrar deneyin.')),
          );
        }
        ref.read(isButtonWorkignProvider.notifier).state = false;
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Bir hata oluştu: $e')),
        );
      }
    } finally {
      ref.read(isButtonWorkignProvider.notifier).state = false;
    }
  }
}
