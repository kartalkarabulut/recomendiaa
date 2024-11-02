import 'package:flutter/material.dart';
import 'package:recomendiaa/core/theme/colors/app_colors.dart';
import 'package:recomendiaa/core/theme/styles/app_text_styles.dart';

class PromptSuggestion extends StatefulWidget {
  const PromptSuggestion({
    super.key,
    required this.promptController,
    required this.prompt,
  });

  final String prompt;
  final TextEditingController promptController;

  @override
  State<PromptSuggestion> createState() => _PromptSuggestionState();
}

class _PromptSuggestionState extends State<PromptSuggestion> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.promptController.text = widget.prompt;
        setState(() {
          isSelected = false;
        });
      },
      onDoubleTap: () {
        setState(() {
          isSelected = !isSelected;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        // width: AppConstants.screenWidth(context) * 0.45,
        height: isSelected ? 100 : 50,
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.yellowGreenColor.withOpacity(0.3),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          "${widget.prompt}",
          overflow: TextOverflow.ellipsis,
          maxLines: isSelected ? 3 : 1,
          style: AppTextStyles.largeTextStyle.copyWith(
              shadows: [Shadow(color: Colors.black, offset: Offset(2, 2))]),
        ),
      ),
    );
  }
}
