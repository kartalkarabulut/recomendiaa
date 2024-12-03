import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recomendiaa/Views/Home/widgets/recomended_book_widget.dart';
import 'package:recomendiaa/providers/book_related_providers.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BooksListView extends ConsumerWidget {
  const BooksListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookRecomendations = ref.watch(getBookRecomendationsProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: bookRecomendations.when(
        data: (data) {
          if (data.isEmpty) {
            return Center(
              child: Text(
                AppLocalizations.of(context)!.youHaveNoRecomendationsYet,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            );
          }
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) => RecomendedBook(
              book: data[index],
              isSmartSuggestion: false,
            ),
          );
        },
        error: (error, stack) => Text(error.toString()),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
