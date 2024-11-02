import 'package:flutter/material.dart';
import 'package:recomendiaa/SharedViews/book_detail_sheet.dart';
import 'package:recomendiaa/core/constants/app_constans.dart';
import 'package:recomendiaa/core/theme/colors/app_colors.dart';
import 'package:recomendiaa/core/theme/colors/gradient_colors.dart';
import 'package:recomendiaa/core/theme/styles/app_text_styles.dart';
import 'package:recomendiaa/models/book_recomendation_model.dart';

class RecomendedBook extends StatelessWidget {
  const RecomendedBook({
    super.key,
    required this.book,
  });

  final BookRecomendationModel book;

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
            height: AppConstants.screenHeight(context) * 0.6,
            width: AppConstants.screenWidth(context),
            decoration: BoxDecoration(
              gradient: AppGradientColors.primaryGradient,
            ),
            child: BookDetailSheet(book: book),
          ),
        );
      },
      child: Container(
        // margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        // height: 130,
        margin: const EdgeInsets.symmetric(vertical: 5),
        height: 120,
        decoration: BoxDecoration(
          color: AppColors.darkBackgorind.withOpacity(0.6),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              book.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.largeTextStyle.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              book.author,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.mediumTextStyle.copyWith(
                color: Colors.orange,
              ),
            ),
            Text(
              book.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.mediumTextStyle.copyWith(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
