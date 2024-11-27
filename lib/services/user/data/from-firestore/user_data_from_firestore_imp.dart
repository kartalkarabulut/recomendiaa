import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recomendiaa/models/user_model.dart';
import 'package:recomendiaa/services/recomendation-history/recomendation_database.dart';
import 'package:recomendiaa/services/user/data/from-firestore/user_data_from_firestore_interface.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserDataFromFirestoreImp implements UserDataFromFirestoreInterface {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _userCollection = 'users';
  final Logger _logger = Logger();

  @override
  Future<UserModel?> getUserData(String userId) async {
    print("getUserData fonksiyonu çağrıldı: $userId");
    try {
      final docSnapshot =
          await _firestore.collection(_userCollection).doc(userId).get();
      if (!docSnapshot.exists) {
        _logger.w('Kullanıcı bulunamadı: $userId');
        // throw UserNotFoundException('Kullanıcı bulunamadı');
      }
      _logger.i('Kullanıcı verileri başarıyla alındı: $userId');
      return UserModel.fromJson(docSnapshot.data() as Map<String, dynamic>);
    } catch (e) {
      _logger.e('Kullanıcı verileri alınırken hata oluştu',
          error: e, stackTrace: StackTrace.current);
      return null;
      // throw FirestoreException('Kullanıcı verileri alınamadı');
    }
  }

  @override
  Future<List<String>> getPromptSuggestions(RecomendationType type) async {
    try {
      final userId = _getCurrentUserId();
      final String field = type == RecomendationType.book
          ? 'lastSuggestedBookPrompts'
          : 'lastSuggestedMoviePrompts';

      final docSnapshot =
          await _firestore.collection(_userCollection).doc(userId).get();
      final data = docSnapshot.data();
      if (data != null && data.containsKey(field)) {
        return List<String>.from(data[field]);
      }
      return [];
    } catch (e) {
      _logger.e('Prompt önerileri alınırken hata oluştu',
          error: e, stackTrace: StackTrace.current);
      return [];
    }
  }

  @override
  Future<List<dynamic>> getSuggestedRecomendations(
      RecomendationType type) async {
    try {
      final userId = _getCurrentUserId();
      final String field = type == RecomendationType.book
          ? 'lastSuggestedBooks'
          : 'lastSuggestedMovies';

      final docSnapshot =
          await _firestore.collection(_userCollection).doc(userId).get();
      final data = docSnapshot.data();
      if (data != null && data.containsKey(field)) {
        return List<dynamic>.from(data[field]);
      }
      return [];
    } catch (e) {
      _logger.e(
          'Önerilen ${type == RecomendationType.book ? 'kitaplar' : 'filmler'} alınırken hata oluştu',
          error: e,
          stackTrace: StackTrace.current);
      return [];
    }
  }

  String _getCurrentUserId() {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      _logger.w('Kullanıcı oturumu açık değil');
      // throw UserNotLoggedInException('Kullanıcı oturumu açık değil');
    }
    return userId!;
  }
}
