import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recomendiaa/services/generation-data/recm_gen_data_interface.dart';
import 'package:logger/logger.dart';

class RecmGenDataImp implements RecomendationGenDataInterface {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Logger _logger = Logger();

  Future<void> updateBookRecomendationData() async {
    try {
      await _firestore.collection('generationdata').doc('stats').set({
        'totalbooks': FieldValue.increment(1),
      }, SetOptions(merge: true)); // Belge yoksa oluştur, varsa güncelle
    } catch (e) {
      _logger.e('Kitap öneri verisi güncellenirken hata oluştu', error: e);
      // rethrow;
    }
  }

  @override
  Future<void> updateMovieRecomendationData() async {
    try {
      await _firestore.collection('generationdata').doc('stats').set({
        'totalmovies': FieldValue.increment(1),
      }, SetOptions(merge: true)); // Belge yoksa oluştur, varsa güncelle
    } catch (e) {
      _logger.e('Film öneri verisi güncellenirken hata oluştu', error: e);
      // rethrow;
    }
  }

  @override
  Future<int?> getBookRecomendationData() async {
    try {
      final docSnapshot =
          await _firestore.collection('generationdata').doc('stats').get();
      if (docSnapshot.exists) {
        return docSnapshot.data()?['totalbooks'] ?? 0;
      }
      return 0;
    } catch (e) {
      _logger.e('Kitap öneri verisi çekilirken hata oluştu', error: e);
      // rethrow;
      return null;
    }
  }

  @override
  Future<int?> getMovieRecomendaitonData() async {
    try {
      final docSnapshot =
          await _firestore.collection('generationdata').doc('stats').get();
      if (docSnapshot.exists) {
        return docSnapshot.data()?['totalmovies'] ?? 0;
      }
      return 0;
    } catch (e) {
      _logger.e('Film öneri verisi çekilirken hata oluştu', error: e);
      // rethrow;
      return null;
    }
  }
}
