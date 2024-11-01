import 'package:hive/hive.dart';

part 'movie_recomendation_model.g.dart';

@HiveType(typeId: 0)
class MovieRecomendationModel extends HiveObject {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String director;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final String posterUrl;

  @HiveField(4)
  final String imdbRating;

  @HiveField(5)
  final List<String> actors;

  @HiveField(6)
  final String genre;

  @HiveField(7)
  final String year;

  @HiveField(8)
  final String duration;

  @HiveField(9)
  final List<String> keywords;

  MovieRecomendationModel({
    required this.title,
    required this.director,
    required this.description,
    required this.posterUrl,
    required this.imdbRating,
    required this.actors,
    required this.genre,
    required this.year,
    required this.duration,
    required this.keywords,
  });

  factory MovieRecomendationModel.fromJson(Map<String, dynamic> json) {
    return MovieRecomendationModel(
      title: json['title'] ?? '',
      director: json['director'] ?? '',
      description: json['description'] ?? '',
      posterUrl: json['posterUrl'] ?? '',
      imdbRating: json['imdbRating'] as String ?? '',
      actors: List<String>.from(json['actors'] ?? []),
      genre: json['genre'] as String ?? '',
      year: json['year'] as String ?? '',
      duration: json['duration'] as String ?? '',
      keywords: List<String>.from(json['keywords'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'director': director,
      'description': description,
      'posterUrl': posterUrl,
      'imdbRating': imdbRating,
      'actors': actors,
      'genre': genre,
      'year': year,
      'duration': duration,
      'keywords': keywords,
    };
  }
}
