import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recomendiaa/Views/Home/widgets/recomended_movie_widget.dart';
import 'package:recomendiaa/providers/movie_providers.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MoviesListView extends ConsumerWidget {
  const MoviesListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movieRecomendations = ref.watch(getAllMovieRecomendations);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: movieRecomendations.when(
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
            itemBuilder: (context, index) => RecomendedMovie(
              isSmartSuggestion: false,
              movie: data[index],
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
