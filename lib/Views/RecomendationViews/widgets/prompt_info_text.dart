import 'package:flutter/material.dart';
import 'package:recomendiaa/core/theme/styles/app_text_styles.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PromptInfoText extends StatelessWidget {
  const PromptInfoText({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          const Icon(
            Icons.info_outline,
            color: Colors.white70,
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              AppLocalizations.of(context)!.promptInfoText,
              style: AppTextStyles.smallTextStyle.copyWith(
                color: Colors.white70,
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
