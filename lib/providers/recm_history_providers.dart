import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recomendiaa/Views/history/recomendation_history_viewmodel.dart';

final recomendationHistoryViewModelProvider = StateNotifierProvider<
    RecomendationHistoryViewModel,
    RecomendationHistoryState>((ref) => RecomendationHistoryViewModel());
