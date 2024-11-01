abstract class RecomendationGenerationInterface {
  Future<dynamic> generateRecomendationByAI(String prompt);
  Future<dynamic> generateSuggestion(
      List<String> previousMoviaNames, List<String> lastSuggestedMoviePrompts);
  Future<dynamic> generatePromptSuggestion(
      List<String>? previousBookNames, List<String>? lovedBookCategories);
}
