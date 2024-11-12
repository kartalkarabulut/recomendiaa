import 'package:flutter/material.dart';
import 'package:recomendiaa/core/theme/colors/app_colors.dart';

class AppGradientColors {
  //Todo: Modify with your own colors and settings
  static LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      AppColors.greenyColor,
      // AppColors.greenyColor,
      AppColors.bluishColor,
      // AppColors.blackColor,
      // AppColors.yellowGreenColor,
    ],
    // transform: GradientRotation(3.14 / 4),
    // stops: [0.0, 0.2, 1.0],
    // tileMode: TileMode.repeated,
  );

  static LinearGradient secondaryGradient = const LinearGradient(
    colors: [
      AppColors.accent100,
      AppColors.accent200,
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 1.0],
    tileMode: TileMode.clamp,
    transform: GradientRotation(4.712389 * 100),
  );
}
