import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:recomendiaa/core/constants/api_constants.dart';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // dotenv paketini ekleyin

import 'package:recomendiaa/models/book_recomendation_model.dart';

class GeminiBookService {
  final GenerativeModel model = GenerativeModel(
      model: 'gemini-1.5-flash', apiKey: dotenv.env['GEMINI_API_KEY'] ?? "");

  Future<List<BookRecomendationModel>> getBooksFromGemini(
      String definition) async {
    String geminiPrompt = ApiConstants().getBookPrompt(definition);
    final content = [Content.text(geminiPrompt)];
    final response = await model.generateContent(content);
    print("the response from gemini \n ${response.text}");
    final jsonData = jsonDecode(response.text!);
    final List<dynamic> booksJson = jsonData['books'];
    print(booksJson);
    return booksJson
        .map((bookJson) =>
            BookRecomendationModel.fromJson(bookJson as Map<String, dynamic>))
        .toList();
  }

  Future<List<BookRecomendationModel>> getBookSuggestionsGemini(
      List<String> previousBookNames, List<String> previousBookPrompts) async {
    String geminiPrompt = ApiConstants()
        .bookSuggestionPrompt(previousBookNames, previousBookPrompts);
    final content = [Content.text(geminiPrompt)];
    final response = await model.generateContent(content);
    print("the book suggestions response from gemini \n ${response.text}");
    final jsonData = jsonDecode(response.text!);
    final List<dynamic> books = jsonData['books'];
    return books
        .map((bookJson) =>
            BookRecomendationModel.fromJson(bookJson as Map<String, dynamic>))
        .toList();
  }

  Future<List<String>> generatePromptSuggestion(
      List<String>? previousPrompts, List<String>? lovedBookCategories) async {
    try {
      print("Prompt önerileri oluşturuluyor...");
      print("Önceki promptlar: $previousPrompts");
      print("Sevilen kategoriler: $lovedBookCategories");

      String geminiPrompt = ApiConstants()
          .getBookPromptSuggestionPrompt(previousPrompts, lovedBookCategories);

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

      final List<dynamic> books = jsonData['suggestedPrompts'];
      print("Oluşturulan prompt önerileri: $books");

      final suggestions = books.map((book) => book.toString()).toList();
      print("İşlenmiş ve dönüştürülmüş öneriler: $suggestions");

      return suggestions;
    } catch (e, stackTrace) {
      print("Prompt önerileri oluşturulurken hata: $e");
      print("Stack trace: $stackTrace");
      rethrow;
    }
  }
}
