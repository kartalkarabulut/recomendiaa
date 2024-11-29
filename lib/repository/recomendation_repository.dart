import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recomendiaa/models/book_recomendation_model.dart';
import 'package:recomendiaa/models/movie_recomendation_model.dart';
import 'package:recomendiaa/services/generation-data/recm_gen_data_imp.dart';
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

  //! This class is for saving total generated recomendation data,
  //! its not about a single user, about all users
  RecmGenDataImp recomendationGenData = RecmGenDataImp();

  Future<List<dynamic>> makeRecomendation(
      String prompt, String language, RecomendationType type) async {
    //Todo: Geminiden öneri alıp, poster url ile birleştirme
    List<dynamic> recomendations = await recomendationGenerationService
        .generateRecomendationByAI(prompt, language);
    // await saveSelectedRecomendations(recomendations, type);

    //Todo: User prompts verisini güncelleme
    await userDataToFirestore.updateUserPrompts(prompt, type);
    if (type == RecomendationType.book) {
      await recomendationGenData.updateBookRecomendationData();
    } else if (type == RecomendationType.movie) {
      await recomendationGenData.updateMovieRecomendationData();
    }
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

  Future<dynamic> initialRecomendation(List<String> lovedCategories,
      List<String> lastSuggestedPrompts, String language) async {
    // List<dynamic> recomendations = await recomendationGenerationService
    //     .generateSuggestion(lovedCategories, lastSuggestedPrompts);
    if (recomendationGenerationService is GenerateBookRecomendation) {
      List<BookRecomendationModel> recomendations =
          await recomendationGenerationService.generateSuggestion(
              lovedCategories, lastSuggestedPrompts, language);
      return recomendations;
    } else if (recomendationGenerationService is GenerateMovieRecomendation) {
      List<MovieRecomendationModel> recomendations =
          await recomendationGenerationService.generateSuggestion(
              lovedCategories, lastSuggestedPrompts, language);
      return recomendations;
    }
  }

  Future<void> generatePromptSuggestion(
      List<String>? previousPrompts,
      List<String>? lovedCategories,
      String language,
      RecomendationType type) async {
    try {
      print('Öneri istekleri oluşturuluyor...');
      final prompts = await recomendationGenerationService
          .generatePromptSuggestion(previousPrompts, lovedCategories, language);

      print(
          'Öneri istekleri başarıyla oluşturuldu. Firestore\'a kaydediliyor...');
      await userDataToFirestore.savePromptSuggestions(prompts, type);

      print('Öneri istekleri başarıyla kaydedildi.');
    } catch (e) {
      print('Öneri istekleri oluşturulurken hata: $e');
      throw Exception('Öneri istekleri oluşturulamadı: $e');
    }
  }

  Future<List<String>> initialGeneratePromptSuggestion(
      List<String>? previousPrompts,
      List<String>? lovedCategories,
      String language,
      RecomendationType type) async {
    final prompts = await recomendationGenerationService
        .generatePromptSuggestion(previousPrompts, lovedCategories, language);
    return prompts;
  }

  Future<List<dynamic>> generateSuggestion(
      List<String> previousPrompts,
      List<String> lovedCategories,
      String language,
      RecomendationType type) async {
    final suggestions = await recomendationGenerationService.generateSuggestion(
        previousPrompts, lovedCategories, language);
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
