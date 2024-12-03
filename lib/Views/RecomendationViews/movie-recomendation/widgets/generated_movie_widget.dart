import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recomendiaa/SharedViews/movie_detail_sheet.dart';
import 'package:recomendiaa/Views/Home/widgets/recomended_movie_widget.dart';
import 'package:recomendiaa/models/movie_recomendation_model.dart';
import 'package:recomendiaa/providers/movie_related_providers.dart';
import 'package:recomendiaa/repository/recomendation_repository.dart';
import 'package:recomendiaa/services/recomendation-history/recomendation_database.dart';
import 'package:recomendiaa/providers/saved_recommendations_provider.dart';

class GeneratedMovieWidget extends ConsumerStatefulWidget {
  const GeneratedMovieWidget({super.key, required this.movie});

  final MovieRecomendationModel movie;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _GeneratedMovieWidgetState();
}

class _GeneratedMovieWidgetState extends ConsumerState<GeneratedMovieWidget>
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

    if (ref.read(savedRecommendationsProvider).contains(widget.movie.title)) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    final movieRepository = ref.read(movieRecomendationRepository);
    final isSelected =
        ref.watch(savedRecommendationsProvider).contains(widget.movie.title);

    return GestureDetector(
      onTap: () {
        // Normal tıklama - Bottom sheet'i aç
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          barrierColor: Colors.transparent,
          enableDrag: true,
          backgroundColor: Colors.black,
          builder: (context) => MovieDetailSheet(
            movie: widget.movie,
            isSmartSuggestion: false,
          ),
        );
      },
      onLongPress: () async {
        final notifier = ref.read(savedRecommendationsProvider.notifier);

        if (!isSelected) {
          _controller.forward();
          await movieRepository.saveSelectedRecomendations(
              [widget.movie], RecomendationType.movie);
          notifier.addRecommendation(widget.movie.title);
        } else {
          _controller.reverse();
          await movieRepository.deleteTheRecomendation(widget.movie.title);
          notifier.removeRecommendation(widget.movie.title);
        }
        ref.invalidate(getAllMovieRecomendations);
      },
      child: Stack(
        children: [
          RecomendedMovie(
            movie: widget.movie,
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
