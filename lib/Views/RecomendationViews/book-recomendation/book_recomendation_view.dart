import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recomendiaa/Views/Auth/login/login_view.dart';
import 'package:recomendiaa/Views/HomePage/widgets/prompt_field.dart';
import 'package:recomendiaa/Views/HomePage/widgets/recomended_book_widget.dart';
import 'package:recomendiaa/Views/RecomendationViews/book-recomendation/book_recm_view_model.dart';
import 'package:recomendiaa/Views/RecomendationViews/book-recomendation/widgets/generated_book_widget.dart';
import 'package:recomendiaa/Views/RecomendationViews/widgets/prompt_suggestion_wigdet.dart';
import 'package:recomendiaa/core/constants/app_constans.dart';
import 'package:recomendiaa/core/theme/colors/app_colors.dart';
import 'package:recomendiaa/core/theme/colors/gradient_colors.dart';
import 'package:recomendiaa/core/theme/styles/app_text_styles.dart';
import 'package:recomendiaa/models/book_recomendation_model.dart';
import 'package:recomendiaa/providers/book_providers.dart';
import 'package:recomendiaa/repository/recomendation_repository.dart';
import 'package:recomendiaa/services/recomendation-generation/book/book_recm_gen_imp.dart';
import 'package:recomendiaa/services/recomendation-history/book_recm_data_imp.dart';
import 'package:recomendiaa/services/recomendation-history/recomendation_database.dart';
import 'package:recomendiaa/services/user/data/to-firestore/user_data_to_firestore_imp.dart';

import '../../../providers/user_data_providers.dart';

class BookRecomendationView extends ConsumerWidget {
  const BookRecomendationView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController promptController = TextEditingController();
    final userData = ref.watch(userDataProvider);
    final bookRecomendationRepository =
        ref.read(bookRecomendationRepositoryProvider);
    final state = ref.watch(bookRecomendationViewModelProvider);
    final bookRecomendationViewModel =
        ref.read(bookRecomendationViewModelProvider.notifier);
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                gradient: AppGradientColors.primaryGradient,
                backgroundBlendMode: BlendMode.lighten),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 0),
              child: Container(color: Colors.black.withOpacity(0.75)),
            ),
          ),
          Column(
            children: [
              // const SizedBox(height: 100),
              SizedBox(
                height: 80,
                child: Center(
                  child: Text(
                    "Book Recomendation",
                    style: AppTextStyles.orbitronlargeTextStyle
                        .copyWith(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              PromptField(
                  promptController: promptController,
                  hintText: "Tell us about your taste in books"),
              userData.when(
                data: (data) {
                  return Wrap(
                    children: [
                      for (var prompt in data!.lastSuggestedBookPrompts)
                        PromptSuggestion(
                            promptController: promptController, prompt: prompt)
                    ],
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(child: Text('Hata: $error')),
              ),
              CustomButton(
                text: "Suggest",
                onPressed: () =>
                    bookRecomendationViewModel.handleSuggestButtonPress(
                        context: context,
                        ref: ref,
                        promptController: promptController),
              )
              // CustomButton(
              //   text: "Suggest",
              //   onPressed: () async {
              //     // if (promptController.text.isEmpty) return;
              //     print(promptController.text);

              //     final recomendations =
              //         await bookRecomendationRepository.makeRecomendation(
              //             promptController.text, RecomendationType.book);

              //     // print(recomendations[0].title);

              //     if (recomendations.isNotEmpty && context.mounted) {
              //       bookRecomendationRepository
              //           .generatePromptSuggestion(
              //               userData.value?.bookPromptHistory,
              //               userData.value?.lovedBookCategories,
              //               RecomendationType.book)
              //           .then(
              //         (value) {
              //           ref.invalidate(userDataProvider);
              //         },
              //       );

              //       bookRecomendationViewModel.generateBookSuggestion(ref);

              //       showModalBottomSheet(
              //         context: context,
              //         isScrollControlled: true,
              //         // showDragHandle: true,
              //         // enableDrag: true,
              //         backgroundColor:
              //             AppColors.yellowGreenColor.withOpacity(0.5),
              //         constraints: BoxConstraints(
              //           maxHeight: AppConstants.screenHeight(context) * 0.7,
              //         ),

              //         builder: (context) {
              //           return BoookRecmSheet(recomendations: recomendations);
              //         },
              //       );
              //     }
              //   },
              // )
            ],
          )
        ],
      ),
    );
  }
}

class BoookRecmSheet extends StatelessWidget {
  const BoookRecmSheet({
    super.key,
    required this.recomendations,
  });

  final List recomendations;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: AppConstants.screenHeight(context) * 0.7,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: AppColors.yellowGreenColor.withOpacity(0.5)),
          child: Column(
            children: [
              const SizedBox(height: 60), // Uyarı mesajı için boşluk
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      for (var book in recomendations)
                        GeneratedBookWidget(book: book)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Text(
            "Lütfen kaydetmek istediğiniz\n kitapları seçin",
            textAlign: TextAlign.center,
            style: AppTextStyles.largeTextStyle.copyWith(
              // color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
