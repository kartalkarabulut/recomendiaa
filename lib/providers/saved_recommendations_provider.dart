import 'package:flutter_riverpod/flutter_riverpod.dart';

final savedRecommendationsProvider =
    StateNotifierProvider<SavedRecommendationsNotifier, Set<String>>((ref) {
  return SavedRecommendationsNotifier();
});

class SavedRecommendationsNotifier extends StateNotifier<Set<String>> {
  SavedRecommendationsNotifier() : super({});

  void addRecommendation(String title) {
    state = {...state, title};
  }

  void removeRecommendation(String title) {
    state = state.where((element) => element != title).toSet();
  }

  bool isRecommendationSaved(String title) {
    return state.contains(title);
  }
}
