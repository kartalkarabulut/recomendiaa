import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recomendiaa/models/book_recomendation_model.dart';
import 'package:recomendiaa/models/movie_recomendation_model.dart';
import 'package:recomendiaa/services/recomendation-generation/book/book_recm_gen_imp.dart';
import 'package:recomendiaa/services/recomendation-generation/movie/movie_recm_gen_imp.dart';
import 'package:recomendiaa/services/recomendation-generation/recomendation_generation_interface.dart';
import 'package:recomendiaa/services/recomendation-history/book_recm_data_imp.dart';
import 'package:recomendiaa/services/recomendation-history/movie_recm_data_imp.dart';
import 'package:recomendiaa/services/recomendation-history/recomendation_database.dart';
import 'package:recomendiaa/services/user/data/to-firestore/user_data_to_firestore_imp.dart';
import 'package:recomendiaa/services/user/data/to-firestore/user_data_to_firestore_interface.dart';

final bookRecomendationRepository = Provider<RecomendationRepository>((ref) {
  return RecomendationRepository(
    recomendationGenerationService: GenerateBookRecomendation(),
    recomendationDatabase: BookRecomendationDataImp(),
    userDataToFirestore: UserDataToFirestoreImp(),
  );
});

final movieRecomendationRepository = Provider<RecomendationRepository>((ref) {
  return RecomendationRepository(
    recomendationGenerationService: GenerateMovieRecomendation(),
    recomendationDatabase: MovieRecomendationDataImp(),
    userDataToFirestore: UserDataToFirestoreImp(),
  );
});

class RecomendationRepository {
  final RecomendationGenerationInterface recomendationGenerationService;
  final RecomendationDatabaseInterface recomendationDatabase;
  final UserDataToFirestoreInterface userDataToFirestore;
  RecomendationRepository({
    required this.recomendationGenerationService,
    required this.recomendationDatabase,
    required this.userDataToFirestore,
  });

  Future<List<dynamic>> makeRecomendation(
      String prompt, RecomendationType type) async {
    //Todo: Geminiden öneri alıp, poster url ile birleştirme
    List<dynamic> recomendations =
        await recomendationGenerationService.generateRecomendationByAI(prompt);
    // await saveSelectedRecomendations(recomendations, type);

    //Todo: User prompts verisini güncelleme
    await userDataToFirestore.updateUserPrompts(prompt, type);
    return recomendations;
  }

  Future<void> saveSelectedRecomendations(
      List<dynamic> recomendations, RecomendationType type) async {
    try {
      await recomendationDatabase.saveRecomendations(recomendations);
      // List<String> recomendationNames = [];
      final recomendationNames = recomendations
          .map((recomendation) => recomendation.title as String)
          .toList();
      await userDataToFirestore.updateSavedRecomendationNames(
        recomendationNames,
        type,
      );
      print("kaydedildi");
    } catch (e) {
      print("kaydedilemedi :$e");
    }
  }

  Future<void> deleteTheRecomendation(String title) async {
    await recomendationDatabase.deleteRecomendation(title);
  }

  Future<void> updateUserPrompts(String prompt, RecomendationType type) async {
    await userDataToFirestore.updateUserPrompts(prompt, type);
  }

  Future<dynamic> initialRecomendation(
      List<String> lovedCategories, List<String> lastSuggestedPrompts) async {
    // List<dynamic> recomendations = await recomendationGenerationService
    //     .generateSuggestion(lovedCategories, lastSuggestedPrompts);
    if (recomendationGenerationService is GenerateBookRecomendation) {
      List<BookRecomendationModel> recomendations =
          await recomendationGenerationService.generateSuggestion(
              lovedCategories, lastSuggestedPrompts);
      return recomendations;
    } else if (recomendationGenerationService is GenerateMovieRecomendation) {
      List<MovieRecomendationModel> recomendations =
          await recomendationGenerationService.generateSuggestion(
              lovedCategories, lastSuggestedPrompts);
      return recomendations;
    }
  }

  Future<void> generatePromptSuggestion(List<String>? previousPrompts,
      List<String>? lovedCategories, RecomendationType type) async {
    final prompts = await recomendationGenerationService
        .generatePromptSuggestion(previousPrompts, lovedCategories);
    await userDataToFirestore.savePromptSuggestions(prompts, type);
  }

  Future<List<String>> initialGeneratePromptSuggestion(
      List<String>? previousPrompts,
      List<String>? lovedCategories,
      RecomendationType type) async {
    final prompts = await recomendationGenerationService
        .generatePromptSuggestion(previousPrompts, lovedCategories);
    return prompts;
  }

  Future<List<dynamic>> generateSuggestion(List<String> previousPrompts,
      List<String> lovedCategories, RecomendationType type) async {
    final suggestions = await recomendationGenerationService.generateSuggestion(
        previousPrompts, lovedCategories);
    return suggestions;
  }

  Future<void> updateLastSuggestedRecomendations(
      List<dynamic> value, RecomendationType type) async {
    await userDataToFirestore.saveSuggestedRecomendations(value, type);
  }
}

final bookRecomendationRepositoryProvider =
    Provider<RecomendationRepository>((ref) {
  return RecomendationRepository(
    recomendationGenerationService: GenerateBookRecomendation(),
    recomendationDatabase: BookRecomendationDataImp(),
    userDataToFirestore: UserDataToFirestoreImp(),
  );
});

final movieRecomendationRepositoryProvider =
    Provider<RecomendationRepository>((ref) {
  return RecomendationRepository(
    recomendationGenerationService: GenerateMovieRecomendation(),
    recomendationDatabase: MovieRecomendationDataImp(),
    userDataToFirestore: UserDataToFirestoreImp(),
  );
});
