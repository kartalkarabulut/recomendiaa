import 'package:recomendiaa/core/constants/api_constants.dart';
import 'package:recomendiaa/models/movie_recomendation_model.dart';
import 'package:recomendiaa/models/user_model.dart';
import 'package:recomendiaa/services/recomendation-generation/movie/movie_poster_url.dart';
import 'package:recomendiaa/services/recomendation-generation/recomendation_generation_interface.dart';
import 'package:recomendiaa/services/recomendation-generation/movie/gemini_movie_service.dart';

//!We need this class because we need to get movie poster url, gemini doesnt provide it
//!so we get it through tmdb api, so we need generate movi recomendation interface
class GenerateMovieRecomendation implements RecomendationGenerationInterface {
  @override
  Future<List<MovieRecomendationModel>> generateRecomendationByAI(
      String definition) async {
    //! Gemini API ile film önerisi oluşturulacak

    List<MovieRecomendationModel> recommendations = [];
    final List<dynamic> films =
        await GeminiMovieService().getFilmsFromGemini(definition);
    for (var film in films) {
      //?Poster url alındı
      String? posterUrl =
          await MoviePosterUrl().getMoviePosterUrl(film["title"]);

      recommendations.add(
        MovieRecomendationModel(
          title: film["title"],
          description: film["description"],
          posterUrl:
              posterUrl.isEmpty || posterUrl == null ? "no-url" : posterUrl,
          genre: film["genre"],
          keywords: film["keywords"],
          director: film["director"],
          imdbRating: film["imdbRating"],
          actors: film["actors"],
          year: film["year"],
          duration: film["duration"],
        ),
      );
    }
    return recommendations;
  }

  @override
  Future<List<MovieRecomendationModel>> generateSuggestion(
      List<String> previousMoviaNames,
      List<String> lastSuggestedMoviePrompts) async {
    List<MovieRecomendationModel> recommendations = [];
    final List<MovieRecomendationModel> films = await GeminiMovieService()
        .getFilmSuggestionsFromGemini(
            previousMoviaNames, lastSuggestedMoviePrompts);
    for (var film in films) {
      String? posterUrl = await MoviePosterUrl().getMoviePosterUrl(film.title);
      recommendations.add(
        MovieRecomendationModel(
          title: film.title ?? "no-url",
          description: film.description ?? "no-description",
          posterUrl:
              posterUrl.isEmpty || posterUrl == null ? "no-url" : posterUrl,
          genre: film.genre ?? "no-genre",
          keywords: film.keywords ?? ["no-keywords"],
          director: film.director ?? "no-director",
          imdbRating: film.imdbRating ?? "no-imdbRating",
          actors: film.actors ?? ["no-actors"],
          year: film.year ?? "no-year",
          duration: film.duration ?? "no-duration",
        ),
      );
    }
    return recommendations;
  }

  @override
  Future<List<String>> generatePromptSuggestion(
      List<String>? previousPrompts, List<String>? lovedMovieCategories) async {
    return await GeminiMovieService()
        .generatePromptSuggestion(previousPrompts, lovedMovieCategories);
  }
}
