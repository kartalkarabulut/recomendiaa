import 'package:flutter/material.dart';
import 'package:recomendiaa/core/constants/app_constans.dart';
import 'package:recomendiaa/core/constants/image_paths.dart';
import 'package:recomendiaa/core/shared-funtcions/all_formatters.dart';
import 'package:recomendiaa/core/theme/colors/app_colors.dart';
import 'package:recomendiaa/core/theme/colors/gradient_colors.dart';
import 'package:recomendiaa/core/theme/styles/app_text_styles.dart';
import 'package:recomendiaa/models/book_recomendation_model.dart';

class BookDetailSheet extends StatelessWidget {
  const BookDetailSheet({super.key, required this.book});

  final BookRecomendationModel book;

  @override
  Widget build(BuildContext context) {
    double screenHeight = AppConstants.screenHeight(context);
    return ClipRRect(
      child: Stack(
        children: [
          Container(
            height: screenHeight * 0.6,
            width: AppConstants.screenWidth(context),
            decoration: BoxDecoration(
              gradient: AppGradientColors.primaryGradient,
            ),
          ),
          Container(
              height: screenHeight * 0.6,
              padding: const EdgeInsets.all(20),
              color: Colors.black.withOpacity(0.5),
              width: AppConstants.screenWidth(context),
              child: SingleChildScrollView(
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Image.asset(
                          ImagePaths.bookHeader,
                          width: 20,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          book.title,
                          style: AppTextStyles.xLargeTextStyle.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      book.genre,
                      style: AppTextStyles.largeTextStyle.copyWith(),
                    ),
                    const SizedBox(height: 10),
                    Text(book.author,
                        style: AppTextStyles.largeTextStyle
                            .copyWith(color: Colors.deepOrange)),
                    const SizedBox(height: 10),
                    Text(
                      '${book.pages} pages',
                      style: AppTextStyles.largeTextStyle.copyWith(),
                    ),
                    const SizedBox(height: 30),
                    Text(book.description, style: AppTextStyles.largeTextStyle),
                    const SizedBox(height: 30),
                    Text(
                      "Related Tags #",
                      style: AppTextStyles.largeTextStyle
                          .copyWith(color: Colors.grey),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Wrap(
                      spacing: 10,
                      runSpacing: 20,
                      children: book.keywords
                          .map((keyword) => Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                decoration: BoxDecoration(
                                  color:
                                      AppColors.darkBackgorind.withOpacity(0.6),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  AllFormatters.capitalizeFirstLetter(keyword),
                                  style: AppTextStyles.largeTextStyle.copyWith(
                                    color: Colors.orange,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ))
                          .toList(),
                    )
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
