abstract class RecomendationGenerationInterface {
  Future<dynamic> generateRecomendationByAI(String prompt, String language);
  Future<dynamic> generateSuggestion(List<String> previousPrompts,
      List<String> lovedCategories, String language);
  Future<dynamic> generatePromptSuggestion(List<String>? previousBookNames,
      List<String>? lovedBookCategories, String language);
}
