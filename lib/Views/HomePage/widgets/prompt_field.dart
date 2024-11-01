import 'package:flutter/material.dart';
import 'package:recomendiaa/core/theme/colors/app_colors.dart';
import 'package:recomendiaa/core/theme/styles/app_text_styles.dart';

class PromptField extends StatelessWidget {
  const PromptField({
    super.key,
    required this.promptController,
    required this.hintText,
  });

  final TextEditingController promptController;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      height: 200,
      decoration: BoxDecoration(
          // image: DecorationImage(
          //   image: AssetImage("assets/images/fieldbg.png"),
          //   fit: BoxFit.fill,
          // ),
          ),
      width: double.infinity,
      child: TextFormField(
        maxLines: 7,
        controller: promptController,
        // keyboardType: TextInputType.multiline,
        style: AppTextStyles.largeTextStyle.copyWith(
          fontWeight: FontWeight.bold,
        ),
        decoration: InputDecoration(
          // filled: false,
          hintText: hintText,
          // fillColor: Colors.grey[400],
          hintStyle: AppTextStyles.largeTextStyle.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
