import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recomendiaa/SharedViews/buttons/custom_button.dart';
import 'package:recomendiaa/models/book_recomendation_model.dart';
import 'package:recomendiaa/providers/book_related_providers.dart';
import 'package:recomendiaa/providers/user_data_providers.dart';
import 'package:recomendiaa/repository/recomendation_repository.dart';
import 'package:recomendiaa/services/ad-services/ads_services.dart';
import 'package:recomendiaa/services/recomendation-generation/book/book_recm_gen_imp.dart';
import 'package:recomendiaa/services/recomendation-history/recomendation_database.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BookRecomendationViewModel extends StateNotifier {
  BookRecomendationViewModel() : super(null);

  Future<void> generateBookSuggestion(WidgetRef ref, String language) async {
    final userData = ref.watch(userDataProvider);
    final bookRecomendationRepository =
        ref.read(bookRecomendationRepositoryProvider);

    List<BookRecomendationModel> bookValue = await GenerateBookRecomendation()
        .generateSuggestion(userData.value?.bookPromptHistory ?? [],
            userData.value?.lovedBookCategories ?? [], language);

    final List<Map<String, dynamic>> bookMaps =
        bookValue.map((book) => book.toJson()).toList();

    bookRecomendationRepository.userDataToFirestore
        .saveSuggestedRecomendations(bookMaps, RecomendationType.book);
    ref.invalidate(userDataProvider);
  }

  Future<void> handleSuggestButtonPress({
    required BuildContext context,
    required WidgetRef ref,
    required TextEditingController promptController,
    required String language,
  }) async {
    if (promptController.text.isEmpty) return;

    // Mevcut önerileri temizle
    ref.read(generatedBookRecommendationsProvider.notifier).state = [];
    ref.read(isButtonWorkignProvider.notifier).state = true;

    try {
      Future.delayed(const Duration(milliseconds: 200));
      NewAdService().showInterstitialAd();

      final userData = ref.watch(userDataProvider);
      final bookRecomendationRepository =
          ref.read(bookRecomendationRepositoryProvider);

      final recomendations =
          await bookRecomendationRepository.makeRecomendation(
              promptController.text, language, RecomendationType.book);

      if (recomendations.isNotEmpty && context.mounted) {
        bookRecomendationRepository
            .generatePromptSuggestion(
                userData.value?.bookPromptHistory,
                userData.value?.lovedBookCategories,
                language,
                RecomendationType.book)
            .then(
          (value) {
            ref.invalidate(userDataProvider);
          },
        );

        generateBookSuggestion(ref, language);

        // Önerileri provider'a kaydet
        ref.read(generatedBookRecommendationsProvider.notifier).state =
            recomendations as List<BookRecomendationModel>;
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(AppLocalizations.of(context)!.error(e.toString()))),
        );
      }
    } finally {
      ref.read(isButtonWorkignProvider.notifier).state = false;
    }
  }
}
