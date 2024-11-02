import 'package:flutter/material.dart';
import 'package:recomendiaa/Views/RecomendationViews/movie-recomendation/movie_recomendation_view.dart';
import 'package:recomendiaa/Views/RecomendationViews/movie-recomendation/widgets/generated_movie_widget.dart';
import 'package:recomendiaa/core/constants/app_constans.dart';
import 'package:recomendiaa/core/theme/colors/app_colors.dart';
import 'package:recomendiaa/core/theme/styles/app_text_styles.dart';
import 'package:recomendiaa/models/movie_recomendation_model.dart';

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
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
