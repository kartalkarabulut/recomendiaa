import 'package:flutter_riverpod/flutter_riverpod.dart';

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
