import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recomendiaa/Views/Auth/login/login_view.dart';
import 'package:recomendiaa/Views/HomePage/widgets/prompt_field.dart';
import 'package:recomendiaa/Views/RecomendationViews/book-recomendation/book_recomendation_view.dart';
import 'package:recomendiaa/core/constants/app_constans.dart';
import 'package:recomendiaa/core/theme/colors/app_colors.dart';
import 'package:recomendiaa/core/theme/colors/gradient_colors.dart';
import 'package:recomendiaa/core/theme/styles/app_text_styles.dart';
import 'package:recomendiaa/models/movie_recomendation_model.dart';
import 'package:recomendiaa/providers/user_data_providers.dart';
import 'package:recomendiaa/services/recomendation-generation/book/book_recm_gen_imp.dart';
import 'package:recomendiaa/services/recomendation-generation/movie/movie_recm_gen_imp.dart';

class MovieRecomendationView extends ConsumerStatefulWidget {
  const MovieRecomendationView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MovieRecomendationViewState();
}

class _MovieRecomendationViewState
    extends ConsumerState<MovieRecomendationView> {
  final promptController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final userData = ref.watch(userDataProvider);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Movie Recomendation',
          style: AppTextStyles.orbitronlargeTextStyle,
        ),
      ),
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
                  // print(promptController.text);

                  final recomendations = await GenerateMovieRecomendation()
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
                                          for (var movie in recomendations)
                                            GeneratedMovieWidget(movie: movie)
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

class GeneratedMovieWidget extends ConsumerStatefulWidget {
  const GeneratedMovieWidget({super.key, required this.movie});

  final MovieRecomendationModel movie;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _GeneratedMovieWidgetState();
}

class _GeneratedMovieWidgetState extends ConsumerState<GeneratedMovieWidget> {
  bool value = false;

  Widget build(BuildContext context) {
    // final selectedBooks = ref.read(selectedBooksProvider);
    // final bookRepository = ref.read(bookRecomendationRepository);
    return Text("meamkema");
    // return Row(
    //   children: [
    //     Checkbox(
    //       value: value,
    //       onChanged: (value) async {
    //         this.value = value!;
    //         if (value) {
    //           ref.read(selectedBooksProvider.notifier).state.add(widget.book);
    //           await bookRepository.saveSelectedRecomendations(
    //               [widget.book], RecomendationType.book);
    //           ref.invalidate(getBookRecomendationProvider);
    //         } else {
    //           ref
    //               .read(selectedBooksProvider.notifier)
    //               .state
    //               .remove(widget.book);
    //           // await bookRepository.deleteSelectedRecomendations(
    //           //     [bookData], RecomendationType.book);
    //         }
    //         print(ref.read(selectedBooksProvider.notifier).state.length);

    //         setState(() {});
    //       },
    //     ),
    //     Expanded(child: RecomendedBook(book: widget.book))
    //   ],
    // );
  }
}
