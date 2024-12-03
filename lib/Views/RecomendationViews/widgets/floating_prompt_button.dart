import 'package:flutter/material.dart';
import 'package:recomendiaa/core/theme/styles/app_text_styles.dart';

class FloatingPromptButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  const FloatingPromptButton({
    Key? key,
    required this.onPressed,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          backgroundColor: Colors.white.withOpacity(0.15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              style: AppTextStyles.mediumTextStyle
                  .copyWith(color: Colors.white, fontWeight: FontWeight.bold
                      // fontSize: 14,
                      ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
              size: 14,
            ),
          ],
        ),
      ),
    );
  }
}
