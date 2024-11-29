import 'package:recomendiaa/models/book_recomendation_model.dart';
import 'package:recomendiaa/services/recomendation-generation/recomendation_generation_interface.dart';
import 'package:recomendiaa/services/recomendation-generation/book/gemini_book_service.dart';

//!We need this class because we need to get movie poster url, gemini doesnt provide it
//!so we get it through tmdb api, so we need generate movi recomendation interface
//!Actually for book recm we dont need this implementation, we use it for making book recomendation
//!and movie recomendation structure same, and later we may need book
class GenerateBookRecomendation implements RecomendationGenerationInterface {
  @override
  Future<List<BookRecomendationModel>> generateRecomendationByAI(
      String prompt, String language) async {
    //! Gemini API ile kitap önerisi oluşturulacak
    final List<BookRecomendationModel> books =
        await GeminiBookService().getBooksFromGemini(prompt, language);
    List<BookRecomendationModel> recommendations = [];
    for (var book in books) {
      recommendations.add(
        BookRecomendationModel(
          title: book.title,
          author: book.author,
          description: book.description,
          pages: book.pages.toString(),
          genre: book.genre,
          keywords: book.keywords,
        ),
      );
    }
    return recommendations;
  }

  @override
  Future<List<BookRecomendationModel>> generateSuggestion(
      List<String> previousBookNames,
      List<String> lastSuggestedBookPrompts,
      String language) async {
    final List<BookRecomendationModel> books = await GeminiBookService()
        .getBookSuggestionsGemini(
            previousBookNames, lastSuggestedBookPrompts, language);
    List<BookRecomendationModel> recommendations = [];
    for (var book in books) {
      recommendations.add(book);
    }
    print("the book suggestions response from gemini \n ${recommendations}");
    return recommendations;
  }

  @override
  Future<List<String>> generatePromptSuggestion(
      List<String>? previousPrompts,
      List<String>? lovedBookCategories,
      String language) async {
    return await GeminiBookService()
        .generatePromptSuggestion(previousPrompts, lovedBookCategories, language);
  }
}
