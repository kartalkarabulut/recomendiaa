import 'package:flutter/material.dart';
import 'package:recomendiaa/Views/RecomendationViews/book-recomendation/widgets/generated_book_widget.dart';
import 'package:recomendiaa/core/constants/app_constans.dart';
import 'package:recomendiaa/core/theme/colors/app_colors.dart';
import 'package:recomendiaa/core/theme/styles/app_text_styles.dart';

class BoookRecmSheet extends StatelessWidget {
  const BoookRecmSheet({
    super.key,
    required this.recomendations,
  });

  final List recomendations;

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
              const SizedBox(height: 60), // Uyarı mesajı için boşluk
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      for (var book in recomendations)
                        GeneratedBookWidget(book: book)
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
              // color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
