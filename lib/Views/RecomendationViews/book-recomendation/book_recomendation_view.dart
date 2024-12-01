import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recomendiaa/SharedViews/buttons/custom_button.dart';
import 'package:recomendiaa/Views/Home/widgets/prompt_field.dart';
import 'package:recomendiaa/Views/Home/widgets/recomended_book_widget.dart';
import 'package:recomendiaa/Views/RecomendationViews/book-recomendation/book_recm_view_model.dart';
import 'package:recomendiaa/Views/RecomendationViews/movie-recomendation/movie_recomendation_view.dart';
import 'package:recomendiaa/Views/RecomendationViews/widgets/prompt_card.dart';
import 'package:recomendiaa/core/theme/colors/gradient_colors.dart';
import 'package:recomendiaa/core/theme/styles/app_text_styles.dart';
import 'package:recomendiaa/providers/book_providers.dart';
import 'package:recomendiaa/repository/recomendation_repository.dart';
import 'package:recomendiaa/services/ad-services/ads_services.dart';

import '../../../providers/user_data_providers.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BookRecomendationView extends ConsumerStatefulWidget {
  const BookRecomendationView({super.key});

  @override
  ConsumerState<BookRecomendationView> createState() =>
      _BookRecomendationViewState();
}

class _BookRecomendationViewState extends ConsumerState<BookRecomendationView> {
  late TextEditingController promptController;
  final NewAdService addServices = NewAdService();
  bool isInterstitialAdReady = false;

  @override
  void initState() {
    super.initState();
    promptController = TextEditingController();
    addServices.loadInterstitialAd();
  }

  @override
  void dispose() {
    promptController.dispose();
    super.dispose();
  }

  void loadInterstitialAd() {
    addServices.loadInterstitialAd();
  }

  void showInterstitialAd() {
    if (isInterstitialAdReady) {
      addServices.showInterstitialAd();
      isInterstitialAdReady = false;
      loadInterstitialAd();
    }
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
                    child: Center(
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back_ios,
                                color: Colors.white),
                            onPressed: () => Navigator.pop(context),
                          ),
                          Text(
                            AppLocalizations.of(context)!.bookRecomendation,
                            style: AppTextStyles.orbitronlargeTextStyle
                                .copyWith(
                                    fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
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
                          color: Colors.black.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.promptSuggestion,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
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
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              'Oluşturduğun öneriler burada gösterilecek',
                              textAlign: TextAlign.center,
                              style: AppTextStyles.mediumTextStyle.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      }

                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              "Son öneriler",
                              textAlign: TextAlign.center,
                              style: AppTextStyles.largeTextStyle.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 360,
                            child: ListView.builder(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              itemCount: generatedRecommendations.length,
                              itemBuilder: (context, index) => RecomendedBook(
                                book: generatedRecommendations[index],
                                isSmartSuggestion: true,
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

class FloatingPromptButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  const FloatingPromptButton({
    Key? key,
    required this.onPressed,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          backgroundColor: Colors.white.withOpacity(0.15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              style: AppTextStyles.mediumTextStyle
                  .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
              size: 14,
            ),
          ],
        ),
      ),
    );
  }
}

class LoadingAnimation extends StatelessWidget {
  const LoadingAnimation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
          const SizedBox(height: 16),
          Text(
            'Kitap önerileri oluşturuluyor...',
            style: AppTextStyles.mediumTextStyle.copyWith(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
