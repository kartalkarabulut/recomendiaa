import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recomendiaa/models/book_recomendation_model.dart';
import 'package:recomendiaa/services/recomendation-history/book_recm_data_imp.dart';
import 'package:recomendiaa/services/recomendation-history/recomendation_database.dart';

final getBookRecomendationProvider =
    FutureProvider<List<BookRecomendationModel>>((ref) async {
  print("kitap önerileri provider çağrıldı");
  return await BookRecomendationDataImp()
      .getRecomendations(RecomendationType.book);
});
