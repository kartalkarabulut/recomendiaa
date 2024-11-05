import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recomendiaa/Views/HomePage/widgets/recomended_book_widget.dart';
import 'package:recomendiaa/providers/book_providers.dart';

class BooksListView extends ConsumerWidget {
  const BooksListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookRecomendations = ref.watch(getBookRecomendationsProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: bookRecomendations.when(
        data: (data) => ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) => RecomendedBook(
            book: data[index],
          ),
        ),
        error: (error, stack) => Text(error.toString()),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
