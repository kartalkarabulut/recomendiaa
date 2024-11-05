import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:recomendiaa/models/book_recomendation_model.dart';
import 'package:recomendiaa/models/movie_recomendation_model.dart';
import 'package:recomendiaa/providers/user_data_providers.dart';
import 'package:recomendiaa/repository/recomendation_repository.dart';
import 'package:recomendiaa/services/recomendation-generation/book/book_recm_gen_imp.dart';
import 'package:recomendiaa/services/recomendation-generation/movie/movie_recm_gen_imp.dart';
import 'package:recomendiaa/services/recomendation-history/recomendation_database.dart';

class HomeState {
  final int currentIndex;

  HomeState({
    this.currentIndex = 0,
  });

  HomeState copyWith({
    int? currentIndex,
  }) {
    return HomeState(
      currentIndex: currentIndex ?? this.currentIndex,
    );
  }
}

class HomeViewModel extends StateNotifier<HomeState> {
  final logger = Logger();
  HomeViewModel() : super(HomeState());

  void setCurrentIndex(int index) {
    state = state.copyWith(currentIndex: index);
  }

  //!Generate book suggestions
  Future<void> generateBookSuggestion(WidgetRef ref) async {
    final userData = ref.watch(userDataProvider);
    final bookRecomendationRepository =
        ref.read(bookRecomendationRepositoryProvider);
    logger.i('--------------- Book Suggestion Data ----------------');
    logger.i('Book Prompt History: ${userData.value!.bookPromptHistory}');
    logger.i('Loved Book Categories: ${userData.value!.lovedBookCategories}');

    List<BookRecomendationModel> bookValue = await GenerateBookRecomendation()
        .generateSuggestion(userData.value?.bookPromptHistory ?? [],
            userData.value?.lovedBookCategories ?? []);

    final List<Map<String, dynamic>> bookMaps =
        bookValue.map((book) => book.toJson()).toList();

    logger.i('Generated ${bookValue.length} book suggestions');

    bookRecomendationRepository.userDataToFirestore
        .saveSuggestedRecomendations(bookMaps, RecomendationType.book);
    logger.i('Book suggestions saved to Firestore');
  }

  //!Generate movie suggestions
  Future<void> generateMovieSuggestion(WidgetRef ref) async {
    final userData = ref.watch(userDataProvider);
    final movieRecomendationRepository =
        ref.read(movieRecomendationRepositoryProvider);
    logger.i('--------------- Movie Suggestion Data ----------------');
    logger.i('Movie Prompt History: ${userData.value!.moviePromptHistory}');
    logger.i('Loved Movie Categories: ${userData.value!.lovedMovieCategories}');

    List<MovieRecomendationModel> movieValue =
        await GenerateMovieRecomendation().generateSuggestion(
            userData.value?.moviePromptHistory ?? [],
            userData.value?.lovedMovieCategories ?? []);

    logger.i('Generated ${movieValue.length} movie suggestions');
    logger.i('Saving movie suggestions to Firestore');

    final List<Map<String, dynamic>> movieMaps =
        movieValue.map((movie) => movie.toJson()).toList();

    movieRecomendationRepository.userDataToFirestore
        .saveSuggestedRecomendations(movieMaps, RecomendationType.movie);
    logger.i('Movie suggestions saved successfully');
  }

  Future<void> generateMovieBookSuggestion(WidgetRef ref) async {
    //?Generate both book and movie suggestions concurrently
    //?then invalidate user data provider when both suggestions are generated
    //?This ensures that the user data is updated with the new suggestions

    logger.i('Starting concurrent generation of book and movie suggestions');

    //!More efficient than generating them one by one with await keyword
    await Future.wait(
      [
        generateBookSuggestion(ref),
        generateMovieSuggestion(ref),
      ],
    );

    ref.invalidate(userDataProvider);
    logger.i('Book and movie suggestions generation completed');
  }
}
