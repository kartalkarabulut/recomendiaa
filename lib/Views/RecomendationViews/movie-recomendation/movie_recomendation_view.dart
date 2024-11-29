import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recomendiaa/SharedViews/buttons/custom_button.dart';
import 'package:recomendiaa/Views/Home/widgets/prompt_field.dart';
import 'package:recomendiaa/Views/RecomendationViews/movie-recomendation/movie_recm_view_model.dart';
import 'package:recomendiaa/Views/RecomendationViews/widgets/prompt_card.dart';
import 'package:recomendiaa/core/theme/colors/gradient_colors.dart';
import 'package:recomendiaa/core/theme/styles/app_text_styles.dart';
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

    return Scaffold(
      resizeToAvoidBottomInset: false,
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
              SizedBox(
                height: 80,
                child: Center(
                  child: Text(
                    AppLocalizations.of(context)!.movieRecomendation,
                    style: AppTextStyles.orbitronlargeTextStyle
                        .copyWith(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              PromptField(
                promptController: promptController,
                hintText:
                    AppLocalizations.of(context)!.tellUsAboutYourTasteInMovies,
              ),
              const SizedBox(height: 30),
              userData.when(
                data: (data) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: SizedBox(
                      height: 120,
                      child: PromptScrollView(
                        prompts: data!.lastSuggestedMoviePrompts,
                        promptController: promptController,
                      ),
                    ),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(
                    child: Text(
                        AppLocalizations.of(context)!.error(error.toString()))),
              ),
              const Spacer(),
              CustomButton(
                text: AppLocalizations.of(context)!.suggest,
                onPressed: () {
                  final language = Localizations.localeOf(context).languageCode;
                  ref
                      .read(movieRecomendationViewModelProvider.notifier)
                      .handleRecomendationGeneration(
                          context, ref, promptController, language);
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
