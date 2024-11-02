import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recomendiaa/Views/Auth/login/login_view.dart';
import 'package:recomendiaa/Views/RecomendationViews/book-recomendation/book_recomendation_view.dart';
import 'package:recomendiaa/core/constants/app_constans.dart';
import 'package:recomendiaa/core/theme/colors/app_colors.dart';
import 'package:recomendiaa/models/book_recomendation_model.dart';
import 'package:recomendiaa/providers/user_data_providers.dart';
import 'package:recomendiaa/repository/recomendation_repository.dart';
import 'package:recomendiaa/services/recomendation-generation/book/book_recm_gen_imp.dart';
import 'package:recomendiaa/services/recomendation-history/recomendation_database.dart';

class BookRecomendationViewModel extends StateNotifier {
  BookRecomendationViewModel() : super(null);

  Future<void> generateBookSuggestion(WidgetRef ref) async {
    final userData = ref.watch(userDataProvider);
    final bookRecomendationRepository =
        ref.read(bookRecomendationRepositoryProvider);
    print(userData.value!.bookPromptHistory.toString());
    print(userData.value!.lovedBookCategories.toString());

    List<BookRecomendationModel> bookValue = await GenerateBookRecomendation()
        .generateSuggestion(userData.value?.bookPromptHistory ?? [],
            userData.value?.lovedBookCategories ?? []);

    print(bookValue.length);
    print("kitap önerileri kaydedilecek");
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
  }) async {
    try {
      ref.read(isButtonWorkignProvider.notifier).state = true;
      final userData = ref.watch(userDataProvider);
      final bookRecomendationRepository =
          ref.read(bookRecomendationRepositoryProvider);

      final recomendations = await bookRecomendationRepository
          .makeRecomendation(promptController.text, RecomendationType.book);

      if (recomendations.isNotEmpty && context.mounted) {
        ref.read(isButtonWorkignProvider.notifier).state = false;
        bookRecomendationRepository
            .generatePromptSuggestion(userData.value?.bookPromptHistory,
                userData.value?.lovedBookCategories, RecomendationType.book)
            .then(
          (value) {
            ref.invalidate(userDataProvider);
          },
        );

        generateBookSuggestion(ref);

        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: AppColors.yellowGreenColor.withOpacity(0.5),
          constraints: BoxConstraints(
            maxHeight: AppConstants.screenHeight(context) * 0.7,
          ),
          builder: (context) => BoookRecmSheet(
            recomendations: recomendations,
          ),
        );
      }
    } catch (e) {
      print("Hata oluştu: $e");
      ref.read(isButtonWorkignProvider.notifier).state = false;
    } finally {
      ref.read(isButtonWorkignProvider.notifier).state = false;
    }
  }
}
