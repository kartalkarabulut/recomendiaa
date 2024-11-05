import 'package:flutter/material.dart';
import 'package:recomendiaa/Views/HomePage/widgets/recomendation_type_widget.dart';
import 'package:recomendiaa/Views/RecomendationViews/book-recomendation/book_recomendation_view.dart';
import 'package:recomendiaa/Views/RecomendationViews/movie-recomendation/movie_recomendation_view.dart';
import 'package:recomendiaa/core/constants/app_constans.dart';

class RecomendationTypesRow extends StatelessWidget {
  const RecomendationTypesRow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RecomendationTypeWidget(
          width: AppConstants.screenWidth(context) * 0.4,
          imagePath: "movie.png",
          title: "Movie Recomendation",
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MovieRecomendationView(),
              ),
            );
          },
        ),
        RecomendationTypeWidget(
          width: AppConstants.screenWidth(context) * 0.4,
          imagePath: "book-stack.png",
          title: "Book Recomendation",
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const BookRecomendationView(),
              ),
            );
          },
        ),
      ],
    );
  }
}
