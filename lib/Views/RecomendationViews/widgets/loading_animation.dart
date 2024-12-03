import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:recomendiaa/core/theme/styles/app_text_styles.dart';

class LoadingAnimation extends StatelessWidget {
  const LoadingAnimation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.suggestionsAreBeingGenerated,
            style: AppTextStyles.mediumTextStyle.copyWith(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
