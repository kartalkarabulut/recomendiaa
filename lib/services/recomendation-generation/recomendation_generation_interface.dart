abstract class RecomendationGenerationInterface {
  Future<dynamic> generateRecomendationByAI(String prompt);
  Future<dynamic> generateSuggestion(
      List<String> previousPrompts, List<String> lovedCategories);
  Future<dynamic> generatePromptSuggestion(
      List<String>? previousBookNames, List<String>? lovedBookCategories);
}
