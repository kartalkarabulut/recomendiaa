import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:recomendiaa/models/movie_recomendation_model.dart';
import 'package:recomendiaa/services/recomendation-history/recomendation_database.dart';

class MovieRecomendationDataImp implements RecomendationDatabaseInterface {
  static const String _boxName = 'movie_recommendations';
  @override
  Future<bool> saveRecomendations(List<dynamic> recomendations) async {
    try {
      final box = await Hive.openBox<MovieRecomendationModel>(_boxName);
      for (var recomendation in recomendations) {
        if (recomendation is MovieRecomendationModel) {
          await box.put(recomendation.title, recomendation);
        }
      }
      await box.close();
      return true;
    } catch (e) {
      print('Önerileri kaydederken hata oluştu: $e');
      return false;
    }
  }

  @override
  Future<List<MovieRecomendationModel>> getRecomendations(
      RecomendationType type) async {
    try {
      final box = await Hive.openBox<MovieRecomendationModel>(_boxName);
      final recommendations = box.values.toList();
      await box.close();
      return recommendations;
    } catch (e) {
      print('Önerileri alırken hata oluştu: $e');
      return [];
    }
  }

  @override
  Future<bool> deleteRecomendation(String title) async {
    try {
      final box = await Hive.openBox<MovieRecomendationModel>(_boxName);
      await box.delete(title);
      await box.close();
      print("silindi");
      return true;
    } catch (e) {
      print('Öneriyi silerken hata oluştu: $e');
      return false;
    }
  }

  @override
  Future<bool> clearAllRecomendations() async {
    try {
      final box = await Hive.openBox<MovieRecomendationModel>(_boxName);
      await box.clear();
      await box.close();
      return true;
    } catch (e) {
      print('Tüm önerileri temizlerken hata oluştu: $e');
      return false;
    }
  }
}
