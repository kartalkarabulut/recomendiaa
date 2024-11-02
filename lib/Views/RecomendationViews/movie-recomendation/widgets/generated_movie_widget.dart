import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recomendiaa/Views/HomePage/widgets/recomended_movie_widget.dart';
import 'package:recomendiaa/models/movie_recomendation_model.dart';
import 'package:recomendiaa/providers/movie_providers.dart';
import 'package:recomendiaa/repository/recomendation_repository.dart';
import 'package:recomendiaa/services/recomendation-history/recomendation_database.dart';

class GeneratedMovieWidget extends ConsumerStatefulWidget {
  const GeneratedMovieWidget({super.key, required this.movie});

  final MovieRecomendationModel movie;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _GeneratedMovieWidgetState();
}

class _GeneratedMovieWidgetState extends ConsumerState<GeneratedMovieWidget> {
  bool value = false;

  Widget build(BuildContext context) {
    // final selectedBooks = ref.read(selectedBooksProvider);
    final movieRepository = ref.read(movieRecomendationRepository);
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: (value) async {
            this.value = value!;
            if (value) {
              await movieRepository.saveSelectedRecomendations(
                  [widget.movie], RecomendationType.movie);
              ref.invalidate(getAllMovieRecomendations);
            } else {
              await movieRepository.deleteTheRecomendation(widget.movie.title);
              ref.invalidate(getAllMovieRecomendations);
            }

            setState(() {});
          },
        ),
        Expanded(child: RecomendedMovie(movie: widget.movie))
      ],
    );
  }
}
