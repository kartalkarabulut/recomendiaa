abstract class RecomendationGenDataInterface {
  Future<void> updateBookRecomendationData();
  Future<void> updateMovieRecomendationData();
  Future<int?> getBookRecomendationData();
  Future<int?> getMovieRecomendaitonData();
}
