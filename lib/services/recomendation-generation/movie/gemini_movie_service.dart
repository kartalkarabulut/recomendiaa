import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:recomendiaa/core/constants/api_constants.dart';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // dotenv paketini ekleyin

import 'package:recomendiaa/models/movie_recomendation_model.dart';

class GeminiMovieService {
  final GenerativeModel model = GenerativeModel(
      model: 'gemini-1.5-flash', apiKey: dotenv.env['GEMINI_API_KEY'] ?? "");

  Future<List<MovieRecomendationModel>> getFilmsFromGemini(
      String definition) async {
    String geminiPrompt = ApiConstants().getMoviePrompt(definition);
    // final model = GenerativeModel(model: 'gemini-pro', apiKey: 'YOUR_API_KEY');
    final content = [Content.text(geminiPrompt)];
    final response = await model.generateContent(content);
    print("the film response from gemini \n ${response.text}");
    final jsonData = jsonDecode(response.text!);

    final List<dynamic> films = jsonData['films'];
    // return films;
    return films
        .map((filmJson) =>
            MovieRecomendationModel.fromJson(filmJson as Map<String, dynamic>))
        .toList();
  }

  Future<List<MovieRecomendationModel>> getFilmSuggestionsFromGemini(
      List<String> previousMovieNames,
      List<String> previousMoviePrompts) async {
    String geminiPrompt = ApiConstants()
        .movieSuggestionPrompt(previousMovieNames, previousMoviePrompts);
    // final model = GenerativeModel(model: 'gemini-pro', apiKey: 'YOUR_API_KEY');
    final content = [Content.text(geminiPrompt)];
    final response = await model.generateContent(content);

    final jsonData = jsonDecode(response.text!);
    print("the film suggestions response from gemini \n ${jsonData}");

    final List<dynamic> films = jsonData['films'];
    // return films;
    return films
        .map((filmJson) =>
            MovieRecomendationModel.fromJson(filmJson as Map<String, dynamic>))
        .toList();
  }

  Future<List<String>> generatePromptSuggestion(
      List<String>? previousPrompts, List<String>? lovedMovieCategories) async {
    String geminiPrompt = ApiConstants()
        .getMoviePromptSuggestionPrompt(previousPrompts, lovedMovieCategories);
    final content = [Content.text(geminiPrompt)];
    final response = await model.generateContent(content);
    final jsonData = jsonDecode(response.text!);
    final List<dynamic> suggestions = jsonData['suggestedPrompts'];
    return suggestions.map((prompt) => prompt.toString()).toList();
  }
}
