import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:recomendiaa/core/constants/api_constants.dart';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // dotenv paketini ekleyin

import 'package:recomendiaa/models/movie_recomendation_model.dart';

class GeminiMovieService {
  final GenerativeModel model = GenerativeModel(
      model: 'gemini-1.5-flash', apiKey: dotenv.env['GEMINI_API_KEY'] ?? "");

  Future<List<MovieRecomendationModel>> getFilmsFromGemini(
      String definition, String language) async {
    String geminiPrompt = ApiConstants().getMoviePrompt(definition, language);
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
      List<String> previousMoviePrompts,
      String language) async {
    String geminiPrompt = ApiConstants().movieSuggestionPrompt(
        previousMovieNames, previousMoviePrompts, language);
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

  Future<List<String>> generatePromptSuggestion(List<String>? previousPrompts,
      List<String>? lovedMovieCategories, String language) async {
    try {
      print("Film önerileri oluşturuluyor...");
      print("Önceki promptlar: $previousPrompts");
      print("Sevilen kategoriler: $lovedMovieCategories");

      String geminiPrompt = ApiConstants().getMoviePromptSuggestionPrompt(
          previousPrompts, lovedMovieCategories, language);

      print("Gemini'ye gönderilen prompt: $geminiPrompt");

      final content = [Content.text(geminiPrompt)];
      final response = await model.generateContent(content);

      if (response.text == null) {
        throw Exception("Gemini'den boş yanıt alındı");
      }

      print("Gemini'den gelen ham yanıt: ${response.text}");

      final jsonData = jsonDecode(response.text!);

      if (!jsonData.containsKey('suggestedPrompts')) {
        throw Exception(
            "Yanıt beklenen formatta değil - 'suggestedPrompts' anahtarı bulunamadı");
      }

      final List<dynamic> suggestions = jsonData['suggestedPrompts'];
      print("Oluşturulan prompt önerileri: $suggestions");

      final processedSuggestions =
          suggestions.map((prompt) => prompt.toString()).toList();
      print("İşlenmiş ve dönüştürülmüş öneriler: $processedSuggestions");

      return processedSuggestions;
    } catch (e, stackTrace) {
      print("Film prompt önerileri oluşturulurken hata: $e");
      print("Stack trace: $stackTrace");
      rethrow;
    }
  }
}
