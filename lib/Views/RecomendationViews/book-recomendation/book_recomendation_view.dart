import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recomendiaa/Views/Auth/login/login_view.dart';
import 'package:recomendiaa/Views/HomePage/widgets/prompt_field.dart';
import 'package:recomendiaa/Views/HomePage/widgets/recomended_book_widget.dart';
import 'package:recomendiaa/core/constants/app_constans.dart';
import 'package:recomendiaa/core/theme/colors/app_colors.dart';
import 'package:recomendiaa/core/theme/colors/gradient_colors.dart';
import 'package:recomendiaa/core/theme/styles/app_text_styles.dart';
import 'package:recomendiaa/models/book_recomendation_model.dart';
import 'package:recomendiaa/providers/book_providers.dart';
import 'package:recomendiaa/repository/recomendation_repository.dart';
import 'package:recomendiaa/services/recomendation-generation/book/book_recm_gen_imp.dart';
import 'package:recomendiaa/services/recomendation-history/recomendation_database.dart';

import '../../../providers/user_data_providers.dart';

// class BookRecomendationState {
//   final String prompt;
//   BookRecomendationState({required this.prompt});
// }

// class BookRecomendationViewModel extends StateNotifier<BookRecomendationState> {
//   BookRecomendationViewModel() : super(BookRecomendationState());
// }

class BookRecomendationView extends ConsumerWidget {
  const BookRecomendationView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController promptController = TextEditingController();
    final userData = ref.watch(userDataProvider);
    final bookRecomendationRepository =
        ref.read(bookRecomendationRepositoryProvider);
    return Scaffold(
      // appBar: AppBar(
      //   centerTitle: true,
      //   backgroundColor: Colors.transparent,
      //   flexibleSpace: Stack(
      //     children: [
      //       Container(
      //         decoration: BoxDecoration(
      //           gradient: AppGradientColors.primaryGradient,
      //         ),
      //       ),
      //       Positioned.fill(
      //         child: BackdropFilter(
      //           filter: ImageFilter.blur(sigmaX: 10, sigmaY: 0),
      //           child: Container(
      //             color: Colors.transparent,
      //             height: 80,
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      //   title: Text(
      //     "Book Recomendation",
      //     style: AppTextStyles.orbitronlargeTextStyle,
      //   ),
      // ),
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
              child: Container(color: Colors.black.withOpacity(0.5)),
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
                onPressed: () async {
                  // if (promptController.text.isEmpty) return;
                  print(promptController.text);

                  final recomendations = await GenerateBookRecomendation()
                      .generateRecomendationByAI(promptController.text);

                  // print(recomendations[0].title);

                  if (recomendations.isNotEmpty && context.mounted) {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      // showDragHandle: true,
                      // enableDrag: true,
                      backgroundColor:
                          AppColors.yellowGreenColor.withOpacity(0.5),
                      constraints: BoxConstraints(
                        maxHeight: AppConstants.screenHeight(context) * 0.7,
                      ),

                      builder: (context) {
                        return Stack(
                          children: [
                            Container(
                              height: AppConstants.screenHeight(context) * 0.7,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: AppColors.yellowGreenColor
                                      .withOpacity(0.5)),
                              child: Column(
                                children: [
                                  const SizedBox(
                                      height: 60), // Uyarı mesajı için boşluk
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
                      },
                    );
                  }
                },
              )
            ],
          )
        ],
      ),
    );
  }
}

final selectedBooksProvider =
    StateProvider<List<BookRecomendationModel>>((ref) {
  return [];
});

class GeneratedBookWidget extends ConsumerStatefulWidget {
  const GeneratedBookWidget({super.key, required this.book});

  final BookRecomendationModel book;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _GeneratedBookWidgetState();
}

class _GeneratedBookWidgetState extends ConsumerState<GeneratedBookWidget> {
  bool value = false;

  Widget build(BuildContext context) {
    final selectedBooks = ref.read(selectedBooksProvider);
    final bookRepository = ref.read(bookRecomendationRepository);
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: (value) async {
            this.value = value!;
            if (value) {
              ref.read(selectedBooksProvider.notifier).state.add(widget.book);
              await bookRepository.saveSelectedRecomendations(
                  [widget.book], RecomendationType.book);
              ref.invalidate(getBookRecomendationProvider);
            } else {
              ref
                  .read(selectedBooksProvider.notifier)
                  .state
                  .remove(widget.book);
              // await bookRepository.deleteSelectedRecomendations(
              //     [bookData], RecomendationType.book);
            }
            print(ref.read(selectedBooksProvider.notifier).state.length);

            setState(() {});
          },
        ),
        Expanded(child: RecomendedBook(book: widget.book))
      ],
    );
  }
}

class PromptSuggestion extends StatefulWidget {
  const PromptSuggestion({
    super.key,
    required this.promptController,
    required this.prompt,
  });

  final String prompt;
  final TextEditingController promptController;

  @override
  State<PromptSuggestion> createState() => _PromptSuggestionState();
}

class _PromptSuggestionState extends State<PromptSuggestion> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.promptController.text = widget.prompt;
        setState(() {
          isSelected = false;
        });
      },
      onDoubleTap: () {
        setState(() {
          isSelected = !isSelected;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        // width: AppConstants.screenWidth(context) * 0.45,
        height: isSelected ? 100 : 50,
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.yellowGreenColor.withOpacity(0.3),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          "${widget.prompt}",
          overflow: TextOverflow.ellipsis,
          maxLines: isSelected ? 3 : 1,
          style: AppTextStyles.largeTextStyle.copyWith(
              shadows: [Shadow(color: Colors.black, offset: Offset(2, 2))]),
        ),
      ),
    );
  }
}
