import 'package:hive_flutter/hive_flutter.dart';
import 'package:recomendiaa/models/book_recomendation_model.dart';
import 'package:recomendiaa/services/recomendation-history/recomendation_database.dart';

class BookRecomendationDataImp implements RecomendationDatabaseInterface {
  static const String _boxName = 'book_recommendations';
  @override
  Future<bool> saveRecomendations(List<dynamic> recomendations) async {
    try {
      final box = await Hive.openBox<BookRecomendationModel>(_boxName);
      print("Kaydedilecek öneri sayısı: ${recomendations.length}");

      for (var recomendation in recomendations) {
        if (recomendation is BookRecomendationModel) {
          await box.put(recomendation.title, recomendation);
          print("Kaydedilen öneri: ${recomendation.title}");
        }
      }

      print("Kayıt sonrası box eleman sayısı: ${box.length}");
      await box.close();
      return true;
    } catch (e) {
      print('Kitap önerilerini kaydederken hata oluştu: $e');
      return false;
    }
  }

  @override
  Future<List<BookRecomendationModel>> getRecomendations(
      RecomendationType type) async {
    try {
      print("kitap önerileri getirilecek");
      final box = await Hive.openBox<BookRecomendationModel>(_boxName);
      final recommendations = box.values.toList();
      await box.close();
      print("kitap önerileri: $recommendations");
      return recommendations;
    } catch (e) {
      print('Kitap önerilerini alırken hata oluştu: $e');
      return [];
    }
  }

  @override
  Future<bool> deleteRecomendation(String title) async {
    try {
      final box = await Hive.openBox<BookRecomendationModel>(_boxName);

      // Silmeden önce kontrol edelim
      final exists = box.containsKey(title);
      print("Silinecek kitap mevcut mu: $exists");
      print("Silmeden önce box içeriği: ${box.keys.toList()}");

      if (exists) {
        await box.delete(title);
        print("Kitap başarıyla silindi: $title");
      } else {
        print("Silinecek kitap bulunamadı: $title");
      }

      await box.close();
      return exists;
    } catch (e) {
      print('Kitap önerisini silerken hata oluştu: $e');
      return false;
    }
  }

  @override
  Future<bool> clearAllRecomendations() async {
    try {
      final box = await Hive.openBox<BookRecomendationModel>(_boxName);
      await box.clear();
      await box.close();
      return true;
    } catch (e) {
      print('Tüm kitap önerilerini temizlerken hata oluştu: $e');
      return false;
    }
  }
}
