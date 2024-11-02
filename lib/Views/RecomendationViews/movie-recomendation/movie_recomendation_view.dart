import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recomendiaa/Views/Auth/login/login_view.dart';
import 'package:recomendiaa/Views/HomePage/widgets/prompt_field.dart';
import 'package:recomendiaa/Views/HomePage/widgets/recomended_movie_widget.dart';
import 'package:recomendiaa/Views/RecomendationViews/book-recomendation/book_recomendation_view.dart';
import 'package:recomendiaa/Views/RecomendationViews/movie-recomendation/movie_recm_view_model.dart';
import 'package:recomendiaa/Views/RecomendationViews/widgets/prompt_suggestion_wigdet.dart';
import 'package:recomendiaa/core/constants/app_constans.dart';
import 'package:recomendiaa/core/theme/colors/app_colors.dart';
import 'package:recomendiaa/core/theme/colors/gradient_colors.dart';
import 'package:recomendiaa/core/theme/styles/app_text_styles.dart';
import 'package:recomendiaa/models/movie_recomendation_model.dart';
import 'package:recomendiaa/providers/movie_providers.dart';
import 'package:recomendiaa/providers/user_data_providers.dart';
import 'package:recomendiaa/repository/recomendation_repository.dart';
import 'package:recomendiaa/services/recomendation-generation/book/book_recm_gen_imp.dart';
import 'package:recomendiaa/services/recomendation-generation/movie/movie_recm_gen_imp.dart';
import 'package:recomendiaa/services/recomendation-history/recomendation_database.dart';

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
                    "Movie Recomendation",
                    style: AppTextStyles.orbitronlargeTextStyle
                        .copyWith(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              PromptField(
                  promptController: promptController,
                  hintText: "Tell us about your taste in movies"),
              userData.when(
                data: (data) {
                  return Wrap(
                    children: [
                      for (var prompt in data!.lastSuggestedMoviePrompts)
                        PromptSuggestion(
                            promptController: promptController, prompt: prompt)
                    ],
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(child: Text('Hata: $error')),
              ),
              const Spacer(),
              CustomButton(
                text: "Suggest",
                onPressed: () => ref
                    .read(movieRecomendationViewModelProvider.notifier)
                    .handleRecomendationGeneration(
                        context, ref, promptController),
              ),
            ],
          )
        ],
      ),
    );
  }
}
