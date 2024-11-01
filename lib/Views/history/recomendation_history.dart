import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recomendiaa/core/theme/colors/app_colors.dart';
import 'package:recomendiaa/core/theme/styles/app_text_styles.dart';
import 'package:recomendiaa/providers/book_providers.dart';

class RecomendationHistory extends ConsumerStatefulWidget {
  const RecomendationHistory({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _RecomendationHistoryState();
}

class _RecomendationHistoryState extends ConsumerState<RecomendationHistory> {
  @override
  Widget build(BuildContext context) {
    final bookRecomendations = ref.watch(getBookRecomendationProvider);
    return Scaffold(
      backgroundColor: AppColors.primary100,
      appBar: AppBar(
        backgroundColor: AppColors.primary100,
        title: Text("Recomendation History"),
      ),
      body: bookRecomendations.when(
        data: (data) => ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) => Text(
            data[index].title,
            style: AppTextStyles.largeTextStyle.copyWith(color: Colors.black),
          ),
        ),
        error: (error, stack) => Text(error.toString()),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
