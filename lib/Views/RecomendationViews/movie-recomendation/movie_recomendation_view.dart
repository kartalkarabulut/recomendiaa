import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recomendiaa/SharedViews/buttons/custom_button.dart';
import 'package:recomendiaa/Views/Home/widgets/prompt_field.dart';
import 'package:recomendiaa/Views/Home/widgets/recomended_movie_widget.dart';
import 'package:recomendiaa/Views/RecomendationViews/movie-recomendation/movie_recm_view_model.dart';
import 'package:recomendiaa/Views/RecomendationViews/widgets/floating_prompt_button.dart';
import 'package:recomendiaa/Views/RecomendationViews/widgets/loading_animation.dart';
import 'package:recomendiaa/Views/RecomendationViews/widgets/prompt_card.dart';
import 'package:recomendiaa/core/theme/colors/gradient_colors.dart';
import 'package:recomendiaa/core/theme/styles/app_text_styles.dart';
import 'package:recomendiaa/providers/movie_related_providers.dart';
import 'package:recomendiaa/providers/user_data_providers.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
                    child: Center(
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back_ios,
                                color: Colors.white),
                            onPressed: () => Navigator.pop(context),
                          ),
                          Text(
                            AppLocalizations.of(context)!.movieRecomendation,
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
                            .tellUsAboutYourTasteInMovies,
                      ),
                      Positioned(
                        right: 25,
                        bottom: 15,
                        child: FloatingPromptButton(
                          onPressed: () async {
                            final language =
                                Localizations.localeOf(context).languageCode;
                            ref
                                .read(movieRecomendationViewModelProvider
                                    .notifier)
                                .handleRecomendationGeneration(
                                    context, ref, promptController, language);
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
                              AppLocalizations.of(context)!
                                  .generatedSuggestionsWillShowUpHere,
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
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                AppLocalizations.of(context)!
                                    .lastMovieSuggestions,
                                textAlign: TextAlign.center,
                                style: AppTextStyles.largeTextStyle.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
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
                              itemBuilder: (context, index) => RecomendedMovie(
                                movie: generatedRecommendations[index],
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
            )
          ],
        ),
      ),
    );
  }
}
