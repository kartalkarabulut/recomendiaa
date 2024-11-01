import 'package:flutter/material.dart';
import 'package:recomendiaa/core/theme/styles/app_text_styles.dart';

class OrText extends StatelessWidget {
  const OrText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Or",
          style: AppTextStyles.largeTextStyle.copyWith(fontSize: 20),
        )
      ],
    );
  }
}
