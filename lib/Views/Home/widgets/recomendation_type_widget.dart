import 'package:flutter/material.dart';
import 'package:recomendiaa/Views/Auth/auth_screen.dart';
import 'package:recomendiaa/core/constants/app_constans.dart';
import 'package:recomendiaa/core/theme/colors/app_colors.dart';
import 'package:recomendiaa/core/theme/colors/gradient_colors.dart';
import 'package:recomendiaa/core/theme/styles/app_text_styles.dart';

class RecomendationTypeWidget extends StatelessWidget {
  const RecomendationTypeWidget({
    super.key,
    this.width,
    this.height,
    required this.imagePath,
    required this.title,
    required this.onTap,
  });

  final double? height;
  final String imagePath;
  final Function() onTap;
  final String title;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        // height: height ?? 150,
        width: width ?? 200,
        padding: const EdgeInsets.all(10),
        // margin: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          gradient: AppGradientColors.primaryGradient,
          borderRadius: BorderRadius.circular(AppConstants.largeBorderRadius),
        ),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        spreadRadius: -2.0,
                        blurRadius: 4.0,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Image.asset("assets/images/$imagePath",
                      height: 60, width: 60),
                ),
                Icon(
                  Icons.arrow_outward_outlined,
                  size: 40,
                  // weight: 300.00,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.5),
                      offset: Offset(0, 1),
                    ),
                  ],
                  color: Colors.deepOrange,
                )
              ],
            ),
            const SizedBox(height: 8),
            Text(
              overflow: TextOverflow.ellipsis,
              title,
              maxLines: 2,
              style: AppTextStyles.mediumTextStyle.copyWith(
                color: AppColors.blackColor,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }
}
