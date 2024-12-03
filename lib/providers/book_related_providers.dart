import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recomendiaa/Views/RecomendationViews/book-recomendation/book_recm_view_model.dart';
import 'package:recomendiaa/models/book_recomendation_model.dart';
import 'package:recomendiaa/services/recomendation-history/book_recm_data_imp.dart';
import 'package:recomendiaa/services/recomendation-history/recomendation_database.dart';

final getBookRecomendationsProvider =
    FutureProvider<List<BookRecomendationModel>>((ref) async {
  return await BookRecomendationDataImp()
      .getRecomendations(RecomendationType.book);
});

final bookRecomendationViewModelProvider =
    StateNotifierProvider<BookRecomendationViewModel, void>((ref) {
  return BookRecomendationViewModel();
});

final generatedBookRecommendationsProvider =
    StateProvider<List<BookRecomendationModel>>((ref) => []);
