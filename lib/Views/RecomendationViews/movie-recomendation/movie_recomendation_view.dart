import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recomendiaa/SharedViews/buttons/custom_button.dart';
import 'package:recomendiaa/Views/Home/widgets/prompt_field.dart';
import 'package:recomendiaa/Views/Home/widgets/recomended_movie_widget.dart';
import 'package:recomendiaa/Views/RecomendationViews/movie-recomendation/widgets/generated_movie_widget.dart';
import 'package:recomendiaa/Views/RecomendationViews/widgets/floating_prompt_button.dart';
import 'package:recomendiaa/Views/RecomendationViews/widgets/loading_animation.dart';
import 'package:recomendiaa/Views/RecomendationViews/widgets/prompt_card.dart';
import 'package:recomendiaa/core/theme/colors/gradient_colors.dart';
import 'package:recomendiaa/core/theme/styles/app_text_styles.dart';
import 'package:recomendiaa/providers/ad_services_providers.dart';
import 'package:recomendiaa/providers/movie_related_providers.dart';
import 'package:recomendiaa/providers/user_data_providers.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:recomendiaa/Views/RecomendationViews/widgets/prompt_info_text.dart';
import 'package:recomendiaa/Views/RecomendationViews/movie-recomendation/widgets/warning_widget.dart';

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
  void initState() {
    super.initState();
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
    final movieAdService = ref.read(moviePageAdServiceProvider);
    movieAdService.loadInterstitialAd();
  }

  @override
  Widget build(BuildContext context) {
    final userData = ref.watch(userDataProvider);
    final generatedRecommendations =
        ref.watch(generatedMovieRecommendationsProvider);

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
                          AppLocalizations.of(context)!.movieRecomendation,
                          style: AppTextStyles.orbitronlargeTextStyle.copyWith(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const PromptInfoText(),
                      Stack(
                        children: [
                          PromptField(
                            promptController: promptController,
                            hintText: AppLocalizations.of(context)!
                                .tellUsAboutYourTasteInMovies,
                          ),
                          Positioned(
                            right: 25,
                            bottom: 15,
                            child: FloatingPromptButton(
                              onPressed: () async {
                                final language = Localizations.localeOf(context)
                                    .languageCode;
                                ref
                                    .read(movieRecomendationViewModelProvider
                                        .notifier)
                                    .handleRecomendationGeneration(context, ref,
                                        promptController, language);
                              },
                              text: AppLocalizations.of(context)!.suggest,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
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
                                prompts: data!.lastSuggestedMoviePrompts,
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
                          .error(error.toString())),
                    ),
                  ),
                  const SizedBox(height: 24),
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
                                  Icons.movie_outlined,
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
                                  Icons.local_movies_outlined,
                                  color: Colors.white,
                                  size: 24,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  AppLocalizations.of(context)!
                                      .lastMovieSuggestions,
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
                              physics: const NeverScrollableScrollPhysics(),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              itemCount: generatedRecommendations.length,
                              itemBuilder: (context, index) => Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: GeneratedMovieWidget(
                                  movie: generatedRecommendations[index],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
