import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recomendiaa/Views/HomePage/widgets/recomended_book_widget.dart';
import 'package:recomendiaa/Views/HomePage/widgets/recomended_movie_widget.dart';
import 'package:recomendiaa/Views/HomePage/widgets/suggestion_selector.dart';
import 'package:recomendiaa/Views/history/widgets/books_listview.dart';
import 'package:recomendiaa/Views/history/widgets/movies_listview.dart';
import 'package:recomendiaa/Views/history/widgets/navigation_button.dart';
import 'package:recomendiaa/core/theme/colors/app_colors.dart';
import 'package:recomendiaa/core/theme/colors/gradient_colors.dart';
import 'package:recomendiaa/core/theme/styles/app_text_styles.dart';
import 'package:recomendiaa/providers/book_providers.dart';
import 'package:recomendiaa/providers/home_page_providers.dart';
import 'package:recomendiaa/providers/movie_providers.dart';

class RecomendationHistoryState {
  RecomendationHistoryState({
    this.isMoviesSelected = true,
    this.currentIndex = 0,
  });

  final int currentIndex;
  final bool isMoviesSelected;

  RecomendationHistoryState copyWith({
    bool? isMoviesSelected,
    int? currentIndex,
  }) {
    return RecomendationHistoryState(
      isMoviesSelected: isMoviesSelected ?? this.isMoviesSelected,
      currentIndex: currentIndex ?? this.currentIndex,
    );
  }
}

class RecomendationHistoryViewModel
    extends StateNotifier<RecomendationHistoryState> {
  RecomendationHistoryViewModel() : super(RecomendationHistoryState());

  void toggleMoviesSelection() {
    state = state.copyWith(isMoviesSelected: !state.isMoviesSelected);
  }

  void setCurrentIndex(int index) {
    state = state.copyWith(currentIndex: index);
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
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final recomendationHistoryViewModel =
        ref.watch(recomendationHistoryViewModelProvider);
    if (_pageController.hasClients &&
        _pageController.page?.round() !=
            recomendationHistoryViewModel.currentIndex) {
      _pageController.animateToPage(recomendationHistoryViewModel.currentIndex,
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: AppGradientColors.primaryGradient,
              backgroundBlendMode: BlendMode.lighten,
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 0),
              child: Container(color: Colors.black.withOpacity(0.75)),
            ),
          ),
          Column(
            children: [
              // const SizedBox(height: 20),
              SizedBox(
                height: 80,
                child: Center(
                  child: Text(
                    "Recomendation History",
                    style: AppTextStyles.orbitronlargeTextStyle.copyWith(
                      fontSize: 24,
                      // fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              // const SizedBox(height: 20),

              // Navigation Buttons
              const HistoryNavigationButtons(),

              // PageView
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    // setState(() {
                    //   _currentPage = index;
                    // });
                    ref
                        .read(recomendationHistoryViewModelProvider.notifier)
                        .setCurrentIndex(index);
                  },
                  children: const [
                    // Movies Page
                    MoviesListView(),

                    // Books Page
                    BooksListView(),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
