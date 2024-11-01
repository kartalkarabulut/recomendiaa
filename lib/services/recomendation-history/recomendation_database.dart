enum RecomendationType {
  movie,
  book,
}

abstract class RecomendationDatabaseInterface {
  Future<bool> saveRecomendations(List<dynamic> recomendations);
  Future<List<dynamic>> getRecomendations(RecomendationType type);
  Future<bool> deleteRecomendation(String id);
  Future<bool> clearAllRecomendations();
}
