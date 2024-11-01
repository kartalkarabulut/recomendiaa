import 'package:recomendiaa/models/user_model.dart';
import 'package:recomendiaa/services/recomendation-history/recomendation_database.dart';

abstract class UserDataToFirestoreInterface {
  Future<void> saveUserData(UserModel user);

  Future<void> updateUserPrompts(String prompt, RecomendationType type);

  Future<void> updateSavedRecomendationNames(
      List<String> savedRecomendationNames, RecomendationType type);

  Future<void> savePromptSuggestions(
      List<String> prompts, RecomendationType type);

  Future<void> saveSuggestedRecomendations(
      List<dynamic> recomendations, RecomendationType type);
}
