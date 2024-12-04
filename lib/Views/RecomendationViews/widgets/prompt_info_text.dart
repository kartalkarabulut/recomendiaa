import 'package:flutter/material.dart';
import 'package:recomendiaa/core/theme/styles/app_text_styles.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PromptInfoText extends StatelessWidget {
  const PromptInfoText({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
            child: Text(
              AppLocalizations.of(context)!.promptInfoText,
              style: AppTextStyles.smallTextStyle.copyWith(
                color: Colors.amber,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
