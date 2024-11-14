import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recomendiaa/SharedViews/movie_detail_sheet.dart';
import 'package:recomendiaa/core/constants/app_constans.dart';
import 'package:recomendiaa/core/shared-funtcions/all_formatters.dart';
import 'package:recomendiaa/core/shared-funtcions/date_time_formatters.dart';
import 'package:recomendiaa/core/theme/colors/app_colors.dart';
import 'package:recomendiaa/core/theme/colors/gradient_colors.dart';
import 'package:recomendiaa/core/theme/styles/app_text_styles.dart';
import 'package:recomendiaa/models/movie_recomendation_model.dart';

class RecomendedMovie extends StatelessWidget {
  const RecomendedMovie({
    super.key,
    required this.movie,
  });

  final MovieRecomendationModel movie;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          barrierColor: Colors.transparent,
          enableDrag: true,
          // showDragHandle: true,
          backgroundColor: Colors.black,
          builder: (context) => Container(
            height: AppConstants.screenHeight(context) * 0.85,
            decoration: BoxDecoration(
              gradient: AppGradientColors.primaryGradient,
            ),
            child: MovieDetailSheet(movie: movie),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        height: 120,
        // width: 100,
        decoration: BoxDecoration(
          color: AppColors.darkBackgorind.withOpacity(0.6),
          // color: Colors.red,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 120,
              child: Image.network(
                movie.posterUrl ?? '',
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 80,
                    color: AppColors.darkBackgorind,
                    child: const Center(
                      child: Icon(
                        Icons.movie_outlined,
                        color: Colors.white54,
                        size: 40,
                      ),
                    ),
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    width: 80,
                    color: AppColors.darkBackgorind,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                },
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.largeTextStyle.copyWith(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "IMDB  ${movie.imdbRating}",
                      style: AppTextStyles.mediumTextStyle.copyWith(
                          color: Colors.orange, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      movie.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.mediumTextStyle
                          .copyWith(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
