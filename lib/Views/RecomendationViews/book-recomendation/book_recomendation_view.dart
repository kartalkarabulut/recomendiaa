import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recomendiaa/SharedViews/buttons/custom_button.dart';
import 'package:recomendiaa/Views/Home/widgets/prompt_field.dart';
import 'package:recomendiaa/Views/Home/widgets/recomended_book_widget.dart';
import 'package:recomendiaa/Views/RecomendationViews/book-recomendation/book_recm_view_model.dart';
import 'package:recomendiaa/Views/RecomendationViews/book-recomendation/widgets/generated_book_widget.dart';
import 'package:recomendiaa/Views/RecomendationViews/movie-recomendation/movie_recomendation_view.dart';
import 'package:recomendiaa/Views/RecomendationViews/widgets/floating_prompt_button.dart';
import 'package:recomendiaa/Views/RecomendationViews/widgets/loading_animation.dart';
import 'package:recomendiaa/Views/RecomendationViews/widgets/prompt_card.dart';
import 'package:recomendiaa/core/theme/colors/gradient_colors.dart';
import 'package:recomendiaa/core/theme/styles/app_text_styles.dart';
import 'package:recomendiaa/providers/ad_services_providers.dart';
import 'package:recomendiaa/providers/book_related_providers.dart';
import 'package:recomendiaa/repository/recomendation_repository.dart';
import 'package:recomendiaa/services/ad-services/ads_services.dart';

import '../../../providers/user_data_providers.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:recomendiaa/Views/RecomendationViews/widgets/prompt_info_text.dart';
import 'package:recomendiaa/Views/RecomendationViews/movie-recomendation/widgets/warning_widget.dart';

class BookRecomendationView extends ConsumerStatefulWidget {
  const BookRecomendationView({super.key});

  @override
  ConsumerState<BookRecomendationView> createState() =>
      _BookRecomendationViewState();
}

class _BookRecomendationViewState extends ConsumerState<BookRecomendationView> {
  late TextEditingController promptController;
  bool isInterstitialAdReady = false;

  @override
  void initState() {
    super.initState();
    promptController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadInterstitialAd();
    });
  }

  @override
  void dispose() {
    promptController.dispose();
    super.dispose();
  }

  void loadInterstitialAd() {
    final bookAdService = ref.read(bookPageAdServiceProvider);
    bookAdService.loadInterstitialAd();
  }

  @override
  Widget build(BuildContext context) {
    final userData = ref.watch(userDataProvider);
    final generatedRecommendations =
        ref.watch(generatedBookRecommendationsProvider);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
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
            SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 80,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.white.withOpacity(0.1),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios,
                              color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          AppLocalizations.of(context)!.bookRecomendation,
                          style: AppTextStyles.orbitronlargeTextStyle.copyWith(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const PromptInfoText(),
                  Stack(
                    children: [
                      PromptField(
                        promptController: promptController,
                        hintText: AppLocalizations.of(context)!
                            .tellUsAboutYourTasteInBooks,
                      ),
                      Positioned(
                        right: 25,
                        bottom: 15,
                        child: FloatingPromptButton(
                          onPressed: () {
                            final language =
                                Localizations.localeOf(context).languageCode;
                            ref
                                .read(
                                    bookRecomendationViewModelProvider.notifier)
                                .handleSuggestButtonPress(
                                  context: context,
                                  ref: ref,
                                  promptController: promptController,
                                  language: language,
                                );
                          },
                          text: AppLocalizations.of(context)!.suggest,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  userData.when(
                    data: (data) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.black38,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white12,
                            width: 1,
                          ),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.promptSuggestion,
                              style: AppTextStyles.mediumTextStyle.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              height: 80,
                              child: PromptScrollView(
                                prompts: data!.lastSuggestedBookPrompts,
                                promptController: promptController,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (error, stack) => Center(
                        child: Text(AppLocalizations.of(context)!
                            .error(error.toString()))),
                  ),
                  const SizedBox(height: 20),
                  Consumer(
                    builder: (context, ref, child) {
                      final isLoading = ref.watch(isButtonWorkignProvider);

                      if (isLoading) {
                        return const Center(
                          child: LoadingAnimation(),
                        );
                      }

                      if (generatedRecommendations.isEmpty) {
                        return Center(
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 32),
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.black26,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.white12,
                                width: 1,
                              ),
                            ),
                            child: Column(
                              children: [
                                const Icon(
                                  Icons.book_outlined,
                                  color: Colors.white54,
                                  size: 48,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  AppLocalizations.of(context)!
                                      .generatedSuggestionsWillShowUpHere,
                                  textAlign: TextAlign.center,
                                  style: AppTextStyles.mediumTextStyle.copyWith(
                                    color: Colors.white70,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.book_outlined,
                                  color: Colors.white,
                                  size: 24,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  AppLocalizations.of(context)!
                                      .lastBookSuggestions,
                                  style: AppTextStyles.largeTextStyle.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          const WarningWidget(),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 400,
                            child: ListView.builder(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              itemCount: generatedRecommendations.length,
                              itemBuilder: (context, index) => Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: GeneratedBookWidget(
                                  book: generatedRecommendations[index],
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
