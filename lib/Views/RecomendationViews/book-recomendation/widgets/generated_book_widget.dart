import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recomendiaa/Views/HomePage/widgets/recomended_book_widget.dart';
import 'package:recomendiaa/models/book_recomendation_model.dart';
import 'package:recomendiaa/providers/book_providers.dart';
import 'package:recomendiaa/repository/recomendation_repository.dart';
import 'package:recomendiaa/services/recomendation-history/recomendation_database.dart';

class GeneratedBookWidget extends ConsumerStatefulWidget {
  const GeneratedBookWidget({super.key, required this.book});

  final BookRecomendationModel book;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _GeneratedBookWidgetState();
}

class _GeneratedBookWidgetState extends ConsumerState<GeneratedBookWidget> {
  bool value = false;

  Widget build(BuildContext context) {
    final bookRepository = ref.read(bookRecomendationRepository);
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: (value) async {
            this.value = value!;
            if (value) {
              // ref.read(selectedBooksProvider.notifier).state.add(widget.book);
              await bookRepository.saveSelectedRecomendations(
                  [widget.book], RecomendationType.book);
              ref.invalidate(getBookRecomendationsProvider);
            } else {
              // ref
              //     .read(selectedBooksProvider.notifier)
              //     .state
              //     .remove(widget.book);
              // await bookRepository.deleteSelectedRecomendations(
              //     [widget.book], RecomendationType.book);
              await bookRepository.recomendationDatabase
                  .deleteRecomendation(widget.book.title);
            }

            setState(() {});
          },
        ),
        Expanded(
          child: RecomendedBook(
            book: widget.book,
            isSmartSuggestion: false,
          ),
        )
      ],
    );
  }
}
