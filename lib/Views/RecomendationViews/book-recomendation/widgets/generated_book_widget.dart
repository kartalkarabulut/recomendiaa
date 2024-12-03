import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recomendiaa/Views/Home/widgets/recomended_book_widget.dart';
import 'package:recomendiaa/models/book_recomendation_model.dart';
import 'package:recomendiaa/providers/book_related_providers.dart';
import 'package:recomendiaa/repository/recomendation_repository.dart';
import 'package:recomendiaa/services/recomendation-history/recomendation_database.dart';
import 'package:recomendiaa/providers/saved_recommendations_provider.dart';

class GeneratedBookWidget extends ConsumerStatefulWidget {
  const GeneratedBookWidget({super.key, required this.book});

  final BookRecomendationModel book;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _GeneratedBookWidgetState();
}

class _GeneratedBookWidgetState extends ConsumerState<GeneratedBookWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    if (ref.read(savedRecommendationsProvider).contains(widget.book.title)) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    final bookRepository = ref.read(bookRecomendationRepository);
    final isSelected =
        ref.watch(savedRecommendationsProvider).contains(widget.book.title);

    return GestureDetector(
      onLongPress: () async {
        final notifier = ref.read(savedRecommendationsProvider.notifier);

        if (!isSelected) {
          _controller.forward();
          await bookRepository.saveSelectedRecomendations(
              [widget.book], RecomendationType.book);
          notifier.addRecommendation(widget.book.title);
        } else {
          _controller.reverse();
          await bookRepository.recomendationDatabase
              .deleteRecomendation(widget.book.title);
          notifier.removeRecommendation(widget.book.title);
        }
        ref.invalidate(getBookRecomendationsProvider);
      },
      child: Stack(
        children: [
          RecomendedBook(
            book: widget.book,
            isSmartSuggestion: true,
          ),
          if (isSelected)
            Positioned(
              left: 8,
              top: 8,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.greenAccent.shade400,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 4,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
