import 'package:hive/hive.dart';
part 'book_recomendation_model.g.dart';

@HiveType(typeId: 1)
class BookRecomendationModel extends HiveObject {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String author;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final String pages;

  @HiveField(4)
  final String genre;

  @HiveField(5)
  final List<String> keywords;

  BookRecomendationModel({
    required this.title,
    required this.author,
    required this.description,
    required this.pages,
    required this.genre,
    required this.keywords,
  });

  factory BookRecomendationModel.fromJson(Map<String, dynamic> json) {
    return BookRecomendationModel(
      title: json['title'],
      author: json['author'],
      description: json['description'],
      pages: json['pages'].toString(),
      genre: json['genre'],
      keywords: List<String>.from(json['keywords'] as List),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'author': author,
      'description': description,
      'pages': pages,
      'genre': genre,
      'keywords': keywords,
    };
  }
}
