import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recomendiaa/Views/HomePage/widgets/recomended_book_widget.dart';
import 'package:recomendiaa/Views/HomePage/widgets/recomended_movie_widget.dart';
import 'package:recomendiaa/Views/HomePage/widgets/suggestion_selector.dart';
import 'package:recomendiaa/core/theme/colors/app_colors.dart';
import 'package:recomendiaa/core/theme/colors/gradient_colors.dart';
import 'package:recomendiaa/core/theme/styles/app_text_styles.dart';
import 'package:recomendiaa/providers/book_providers.dart';
import 'package:recomendiaa/providers/home_page_providers.dart';
import 'package:recomendiaa/providers/movie_providers.dart';

class RecomendationHistoryState {
  bool isMoviesSelected;
  RecomendationHistoryState({this.isMoviesSelected = true});
}

class RecomendationHistoryViewModel
    extends StateNotifier<RecomendationHistoryState> {
  RecomendationHistoryViewModel() : super(RecomendationHistoryState());

  void toggleMoviesSelection() {
    state =
        RecomendationHistoryState(isMoviesSelected: !state.isMoviesSelected);
  }
}

final recomendationHistoryViewModelProvider = StateNotifierProvider<
    RecomendationHistoryViewModel,
    RecomendationHistoryState>((ref) => RecomendationHistoryViewModel());

class RecomendationHistory extends ConsumerStatefulWidget {
  const RecomendationHistory({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _RecomendationHistoryState();
}

class _RecomendationHistoryState extends ConsumerState<RecomendationHistory> {
  @override
  Widget build(BuildContext context) {
    final bookRecomendations = ref.watch(getBookRecomendationsProvider);
    final movieRecomendations = ref.watch(getAllMovieRecomendations);
    final recomendationHistoryViewModel =
        ref.watch(recomendationHistoryViewModelProvider);
    return Scaffold(
      // backgroundColor: AppColors.primary100,
      // appBar: AppBar(
      //   backgroundColor: AppColors.primary100,
      //   title: Text("Recomendation History"),
      // ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                gradient: AppGradientColors.primaryGradient,
                backgroundBlendMode: BlendMode.lighten),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 0),
              child: Container(color: Colors.black.withOpacity(0.75)),
            ),
          ),
          Column(
            children: [
              const SizedBox(height: 30),
              SuggestionSelector(
                firstTitle: "Movies",
                secondTitle: "Books",
                onSelectionChanged: (isFirstSelected) {
                  ref
                      .read(recomendationHistoryViewModelProvider.notifier)
                      .toggleMoviesSelection();
                },
                isFirstSelected: recomendationHistoryViewModel.isMoviesSelected,
              ),
              Expanded(
                child: !recomendationHistoryViewModel.isMoviesSelected
                    ? bookRecomendations.when(
                        data: (data) => ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (context, index) => RecomendedBook(
                            book: data[index],
                          ),
                        ),
                        error: (error, stack) => Text(error.toString()),
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                      )
                    : movieRecomendations.when(
                        data: (data) => ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (context, index) => RecomendedMovie(
                            movie: data[index],
                          ),
                        ),
                        error: (error, stack) => Text(error.toString()),
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
