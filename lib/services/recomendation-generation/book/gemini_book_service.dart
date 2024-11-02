import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:recomendiaa/core/constants/api_constants.dart';
import 'dart:convert';

import 'package:recomendiaa/models/book_recomendation_model.dart';

class GeminiBookService {
  final GenerativeModel model = GenerativeModel(
      model: 'gemini-1.5-flash', apiKey: ApiConstants.geminiApiKey);

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
    String geminiPrompt = ApiConstants()
        .getBookPromptSuggestionPrompt(previousPrompts, lovedBookCategories);
    final content = [Content.text(geminiPrompt)];
    final response = await model.generateContent(content);

    final jsonData = jsonDecode(response.text!);
    final List<dynamic> books = jsonData['suggestedPrompts'];
    return books.map((book) => book.toString()).toList();
  }
}
