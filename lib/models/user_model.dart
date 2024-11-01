import 'package:recomendiaa/models/book_recomendation_model.dart';
import 'package:recomendiaa/models/movie_recomendation_model.dart';

class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String password;
  List<String> bookPromptHistory;
  List<String> moviePromptHistory;
  List<String> savedMovies;
  List<String> savedBooks;
  List<String> lastSuggestedMoviePrompts;
  List<MovieRecomendationModel> lastSuggestedMovies;
  List<String> lastSuggestedBookPrompts;
  List<BookRecomendationModel> lastSuggestedBooks;
  List<String> lovedMovieCategories;
  List<String> lovedBookCategories;

  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.password,
    required this.bookPromptHistory,
    required this.moviePromptHistory,
    required this.savedMovies,
    required this.savedBooks,
    required this.lastSuggestedMoviePrompts,
    required this.lastSuggestedMovies,
    required this.lastSuggestedBookPrompts,
    required this.lastSuggestedBooks,
    required this.lovedMovieCategories,
    required this.lovedBookCategories,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      fullName: json['fullName'],
      email: json['email'],
      password: json['password'],
      bookPromptHistory: List<String>.from(json['bookPromptHistory']),
      moviePromptHistory: List<String>.from(json['moviePromptHistory']),
      savedMovies: List<String>.from(json['savedMovies']),
      savedBooks: List<String>.from(json['savedBooks']),
      lastSuggestedMoviePrompts:
          List<String>.from(json['lastSuggestedMoviePrompts']),
      lastSuggestedMovies: (json['lastSuggestedMovies'] as List?)
              ?.map((movie) => MovieRecomendationModel.fromJson(movie))
              .toList() ??
          [],
      lastSuggestedBookPrompts:
          List<String>.from(json['lastSuggestedBookPrompts']),
      lastSuggestedBooks: (json['lastSuggestedBooks'] as List?)
              ?.map((book) => BookRecomendationModel.fromJson(book))
              .toList() ??
          [],
      lovedMovieCategories: List<String>.from(json['lovedMovieCategories']),
      lovedBookCategories: List<String>.from(json['lovedBookCategories']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'password': password,
      'bookPromptHistory': bookPromptHistory,
      'moviePromptHistory': moviePromptHistory,
      'savedMovies': savedMovies,
      'savedBooks': savedBooks,
      'lastSuggestedMoviePrompts': lastSuggestedMoviePrompts,
      'lastSuggestedMovies':
          lastSuggestedMovies.map((movie) => movie.toJson()).toList(),
      'lastSuggestedBookPrompts': lastSuggestedBookPrompts,
      'lastSuggestedBooks':
          lastSuggestedBooks.map((book) => book.toJson()).toList(),
      'lovedMovieCategories': lovedMovieCategories,
      'lovedBookCategories': lovedBookCategories,
    };
  }

  UserModel copyWith({
    String? id,
    String? fullName,
    String? email,
    String? password,
    List<String>? bookPromptHistory,
    List<String>? moviePromptHistory,
    List<String>? savedMovies,
    List<String>? savedBooks,
    List<String>? lastSuggestedMoviePrompts,
    List<MovieRecomendationModel>? lastSuggestedMovies,
    List<String>? lastSuggestedBookPrompts,
    List<BookRecomendationModel>? lastSuggestedBooks,
    List<String>? lovedMovieCategories,
    List<String>? lovedBookCategories,
  }) {
    return UserModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      password: password ?? this.password,
      bookPromptHistory: bookPromptHistory ?? this.bookPromptHistory,
      moviePromptHistory: moviePromptHistory ?? this.moviePromptHistory,
      savedMovies: savedMovies ?? this.savedMovies,
      savedBooks: savedBooks ?? this.savedBooks,
      lastSuggestedMoviePrompts:
          lastSuggestedMoviePrompts ?? this.lastSuggestedMoviePrompts,
      lastSuggestedMovies: lastSuggestedMovies ?? this.lastSuggestedMovies,
      lastSuggestedBookPrompts:
          lastSuggestedBookPrompts ?? this.lastSuggestedBookPrompts,
      lastSuggestedBooks: lastSuggestedBooks ?? this.lastSuggestedBooks,
      lovedMovieCategories: lovedMovieCategories ?? this.lovedMovieCategories,
      lovedBookCategories: lovedBookCategories ?? this.lovedBookCategories,
    );
  }
}
