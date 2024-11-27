import 'package:flutter/material.dart';
import 'package:recomendiaa/Views/RecomendationViews/movie-recomendation/movie_recomendation_view.dart';
import 'package:recomendiaa/Views/RecomendationViews/movie-recomendation/widgets/generated_movie_widget.dart';
import 'package:recomendiaa/core/constants/app_constans.dart';
import 'package:recomendiaa/core/theme/colors/app_colors.dart';
import 'package:recomendiaa/core/theme/styles/app_text_styles.dart';
import 'package:recomendiaa/models/movie_recomendation_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MovieRecmSheet extends StatelessWidget {
  const MovieRecmSheet({
    super.key,
    required this.recomendations,
  });

  final List<MovieRecomendationModel> recomendations;

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
              const SizedBox(height: 60),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
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
          top: 10,
          left: 0,
          right: 0,
          child: Text(
            AppLocalizations.of(context)!.pleaseSelectTheMoviesYouWantToSave,
            textAlign: TextAlign.center,
            style: AppTextStyles.largeTextStyle.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
