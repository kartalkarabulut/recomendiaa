import 'dart:convert';

import 'package:http/http.dart' as http;

class MoviePosterUrl {
  static const apiKey = '6c442229b526bde05d75cd22c8f7b4e8';
  static const baseUrl = 'https://api.themoviedb.org/3';

  Future<String> getMoviePosterUrl(String movieTitle) async {
    final response = await http.get(
      Uri.parse('$baseUrl/search/movie?api_key=$apiKey&query=$movieTitle'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final results = data['results'] as List;

      if (results.isNotEmpty) {
        final movie = results[0];
        final posterPath = movie['poster_path'] as String;
        final posterUrl = 'https://image.tmdb.org/t/p/w500$posterPath';
        return posterUrl;
      } else {
        return 'Film bulunamadı.';
      }
    } else {
      throw Exception('API çağrısı başarısız oldu.');
    }
  }
}
