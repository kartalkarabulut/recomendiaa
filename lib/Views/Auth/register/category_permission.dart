import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recomendiaa/core/theme/styles/app_text_styles.dart';

class CategoryPermission extends ConsumerWidget {
  const CategoryPermission({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Text(
          "To be able\n to recommend you \nthe best content, \nwe need to know your \nfavorite categories",
          style: AppTextStyles.xLargeTextStyle
              .copyWith(fontWeight: FontWeight.bold, fontSize: 30),
        ),
      ),
    );
  }
}
