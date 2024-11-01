import 'package:recomendiaa/models/user_model.dart';
import 'package:recomendiaa/services/recomendation-history/recomendation_database.dart';

abstract class UserDataFromFirestoreInterface {
  Future<UserModel?> getUserData(String userId);

  Future<List<dynamic>> getSuggestedRecomendations(RecomendationType type);

  Future<List<String>> getPromptSuggestions(RecomendationType type);
}
