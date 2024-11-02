import 'package:flutter/material.dart';
import 'package:recomendiaa/core/constants/app_constans.dart';
import 'package:google_fonts/google_fonts.dart';
import '../colors/app_colors.dart';

class AppTextStyles {
  static TextStyle orbitronlargeTextStyle = GoogleFonts.orbitron(
    fontSize: AppConstants.largeFontSize,
    color: AppColors.text100,
  );
  static TextStyle largeTextStyle = GoogleFonts.ubuntu(
    fontSize: AppConstants.largeFontSize,
    color: AppColors.text100,
  );
  static TextStyle xLargeTextStyle = GoogleFonts.ubuntu(
    fontSize: AppConstants.xLargeFontSize,
    color: AppColors.text100,
  );

  static TextStyle mediumTextStyle = GoogleFonts.ubuntu(
    fontSize: AppConstants.mediumFontSize,
    color: AppColors.text100,
  );

  static TextStyle smallTextStyle = const TextStyle(
    fontSize: AppConstants.smallFontSize,
    color: AppColors.text100,
  );

  //?Link text style
  static final TextStyle linkStyle = GoogleFonts.openSans(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Colors.blue,
    decoration: TextDecoration.underline,
  );

  //?Button text style
  static final TextStyle buttonText = GoogleFonts.roboto(
    fontSize: AppConstants.xLargeFontSize,
    color: AppColors.text100,
    fontWeight: FontWeight.w500,
    // letterSpacing: 1.25,
  );

  //?Google Fonts
  //?Large text style
  static final TextStyle largeTextStyleGF = GoogleFonts.openSans(
    fontSize: AppConstants.largeFontSize,
    color: AppColors.text100,
  );
  //?Medium text style
  static final TextStyle mediumTextStyleGF = GoogleFonts.openSans(
    fontSize: AppConstants.mediumFontSize,
    color: AppColors.text100,
  );
  //?Small text style
  static final TextStyle smallTextStyleGF = GoogleFonts.openSans(
    fontSize: AppConstants.smallFontSize,
    color: AppColors.text100,
  );
}
