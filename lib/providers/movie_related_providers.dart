import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recomendiaa/Views/RecomendationViews/movie-recomendation/movie_recm_view_model.dart';
import 'package:recomendiaa/models/movie_recomendation_model.dart';
import 'package:recomendiaa/services/recomendation-history/movie_recm_data_imp.dart';
import 'package:recomendiaa/services/recomendation-history/recomendation_database.dart';

final getAllMovieRecomendations =
    FutureProvider<List<MovieRecomendationModel>>((ref) async {
  return await MovieRecomendationDataImp()
      .getRecomendations(RecomendationType.movie);
});

final isGeneratingMovieProvider = StateProvider<bool>((ref) {
  return false;
});
final generatedMovieRecommendationsProvider =
    StateProvider<List<MovieRecomendationModel>>((ref) => []);
final movieRecomendationViewModelProvider =
    StateNotifierProvider<MovieRecomendationViewModel, void>((ref) {
  return MovieRecomendationViewModel();
});
