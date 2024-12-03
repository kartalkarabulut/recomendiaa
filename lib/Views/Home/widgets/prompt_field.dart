import 'package:flutter/material.dart';
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
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 200,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        // image: DecorationImage(
        //   image: AssetImage("assets/images/fieldbg.png"),
        //   fit: BoxFit.fill,
        // ),
      ),
      width: double.infinity,
      child: TextFormField(
        maxLines: 7,
        controller: promptController,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        onEditingComplete: () {
          FocusScope.of(context).unfocus(); // Klavyeyi kapatır
        },
        onFieldSubmitted: (value) {
          FocusScope.of(context).unfocus(); // Klavyeyi kapatır
        },
        // keyboardType: TextInputType.multiline,
        autofocus: false,
        style: AppTextStyles.largeTextStyle.copyWith(
            // fontWeight: FontWeight.bold,
            ),
        decoration: InputDecoration(
            filled: true,
            fillColor: Colors.black38,
            hintText: hintText,
            // fillColor: Colors.grey[400],
            hintStyle: AppTextStyles.mediumTextStyle),
      ),
    );
  }
}
