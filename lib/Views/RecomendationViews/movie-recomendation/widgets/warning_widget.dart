import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:recomendiaa/core/theme/styles/app_text_styles.dart';

class WarningWidget extends StatelessWidget {
  const WarningWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final String warningText = AppLocalizations.of(context)!.warningText;
    final List<String> textParts = warningText.split('. ');

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.amber.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.amber.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.info_outline,
            color: Colors.amber,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: AppTextStyles.smallTextStyle.copyWith(
                  color: Colors.amber,
                  height: 1.4,
                ),
                children: [
                  TextSpan(text: '${textParts[0]}. '),
                  TextSpan(
                    text: textParts[1],
                    style: AppTextStyles.smallTextStyle.copyWith(
                      color: Colors.red,
                      // fontSize: 14,
                      fontWeight: FontWeight.bold,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
