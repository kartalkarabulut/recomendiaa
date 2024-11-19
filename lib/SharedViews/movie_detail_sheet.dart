import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recomendiaa/SharedViews/shared_snackbars.dart';
import 'package:recomendiaa/core/constants/app_constans.dart';
import 'package:recomendiaa/core/shared-funtcions/all_formatters.dart';
import 'package:recomendiaa/core/theme/colors/app_colors.dart';
import 'package:recomendiaa/core/theme/colors/gradient_colors.dart';
import 'package:recomendiaa/core/theme/styles/app_text_styles.dart';
import 'package:recomendiaa/models/movie_recomendation_model.dart';
import 'package:recomendiaa/providers/movie_providers.dart';
import 'package:recomendiaa/services/recomendation-history/movie_recm_data_imp.dart';

class MovieDetailSheet extends StatelessWidget {
  const MovieDetailSheet({
    super.key,
    required this.movie,
    required this.isSmartSuggestion,
  });

  final MovieRecomendationModel movie;
  final bool isSmartSuggestion;

  @override
  Widget build(BuildContext context) {
    double screenHeight = AppConstants.screenHeight(context);
    return ClipRRect(
      child: Stack(
        children: [
          Container(
            height: screenHeight * 0.85,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: AppGradientColors.primaryGradient,
            ),
          ),
          Container(
            height: screenHeight * 0.85,
            color: Colors.black.withOpacity(0.5),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(height: 20),
                  SizedBox(
                    height: screenHeight * 0.3,
                    child: Row(
                      children: [
                        Image.network(movie.posterUrl,
                            height: screenHeight * 0.3),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(movie.title,
                                  maxLines: 3,
                                  style: AppTextStyles.largeTextStyle.copyWith(
                                    fontWeight: FontWeight.bold,
                                  )),
                              Text(movie.year,
                                  style: AppTextStyles.largeTextStyle
                                      .copyWith(color: AppColors.bluishColor)),
                              // const SizedBox(height: 10),
                              Text(movie.genre,
                                  style: AppTextStyles.largeTextStyle),
                              // const SizedBox(height: 10),
                              Text("${movie.duration} min",
                                  style: AppTextStyles.largeTextStyle
                                      .copyWith(color: AppColors.bluishColor)),
                              // const SizedBox(height: 10),
                              Text(
                                "IMDB ${movie.imdbRating}",
                                style: AppTextStyles.largeTextStyle.copyWith(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image.asset(
                              "assets/images/film-director.png",
                              // color: Colors.orange,
                              width: 30,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              movie.director,
                              style: AppTextStyles.largeTextStyle,
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Image.asset(
                              "assets/images/actor.png",
                              // color: Colors.orange,
                              width: 30,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                movie.actors.join(", "),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.largeTextStyle,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text(
                          movie.description,
                          style: AppTextStyles.largeTextStyle,
                        ),
                        const SizedBox(height: 20),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: movie.keywords
                              .map((keyword) => Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    decoration: BoxDecoration(
                                      color: AppColors.darkBackgorind
                                          .withOpacity(0.6),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      AllFormatters.capitalizeFirstLetter(
                                          keyword),
                                      style:
                                          AppTextStyles.largeTextStyle.copyWith(
                                        color: Colors.orange,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ))
                              .toList(),
                        ),
                        isSmartSuggestion
                            ? const SizedBox()
                            : Consumer(
                                builder: (context, ref, child) {
                                  return TextButton(
                                    onPressed: () async {
                                      await MovieRecomendationDataImp()
                                          .deleteRecomendation(movie.title);
                                      ref.invalidate(getAllMovieRecomendations);
                                      SharedSnackbars.showSuccessSnackBar(
                                          context, "Movie Deleted");
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      "Delete This Movie ",
                                      style:
                                          AppTextStyles.largeTextStyle.copyWith(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                        shadows: [
                                          const Shadow(
                                            color: Colors.black,
                                            offset: Offset(1, 1),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
