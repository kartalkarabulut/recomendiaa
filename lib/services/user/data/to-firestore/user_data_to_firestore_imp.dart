import 'package:recomendiaa/models/user_model.dart';
import 'package:recomendiaa/services/recomendation-history/recomendation_database.dart';
import 'package:recomendiaa/services/user/data/to-firestore/user_data_to_firestore_interface.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserDataToFirestoreImp implements UserDataToFirestoreInterface {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _userCollection = 'users';
  final Logger _logger = Logger();

  @override
  Future<void> saveUserData(UserModel user) async {
    print("----saveuserdata çalıştı");
    print(
        "kullanıcı verisi kaydediliyor ${user.lastSuggestedBooks.first.title}");
    print("kullanıcı verisi kaydediliyor örneği${user.lastSuggestedBooks}");
    try {
      await _firestore
          .collection(_userCollection)
          .doc(user.id)
          .set(user.toJson());
      _logger.i('Kullanıcı verileri başarıyla kaydedildi: ${user.id}');
    } catch (e) {
      _logger.e('Kullanıcı verileri kaydedilirken hata oluştu',
          error: e, stackTrace: StackTrace.current);
      // throw FirestoreException('Kullanıcı verileri kaydedilemedi');
    }
  }

  @override
  Future<void> updateUserPrompts(String prompt, RecomendationType type) async {
    try {
      final userId = _getCurrentUserId();
      final String field = type == RecomendationType.book
          ? 'bookPromptHistory'
          : 'moviePromptHistory';

      await _firestore.collection(_userCollection).doc(userId).update({
        field: FieldValue.arrayUnion([prompt])
      });
      _logger.i('Kullanıcı promptu başarıyla güncellendi: $userId, $type');
    } catch (e) {
      _logger.e('Kullanıcı promptları güncellenirken hata oluştu',
          error: e, stackTrace: StackTrace.current);
      // throw FirestoreException('Kullanıcı promptları güncellenemedi');
    }
  }

  @override
  Future<void> updateSavedRecomendationNames(
      List<String> savedRecomendationNames, RecomendationType type) async {
    try {
      final userId = _getCurrentUserId();
      final String field =
          type == RecomendationType.book ? 'savedBooks' : 'savedMovies';

      await _firestore
          .collection(_userCollection)
          .doc(userId)
          .update({field: FieldValue.arrayUnion(savedRecomendationNames)});
      _logger.i('Kaydedilen öneriler başarıyla güncellendi: $userId, $type');
    } catch (e) {
      _logger.e('Kaydedilen öneriler güncellenirken hata oluştu',
          error: e, stackTrace: StackTrace.current);
      // throw FirestoreException('Kaydedilen öneriler güncellenemedi');
    }
  }

  @override
  Future<void> savePromptSuggestions(
      List<String> prompts, RecomendationType type) async {
    final userId = _getCurrentUserId();
    final String field = type == RecomendationType.book
        ? 'lastSuggestedBookPrompts'
        : 'lastSuggestedMoviePrompts';

    await _firestore
        .collection(_userCollection)
        .doc(userId)
        .update({field: prompts});
  }

  @override
  Future<void> saveSuggestedRecomendations(
      List<dynamic> recomendations, RecomendationType type) async {
    final userId = _getCurrentUserId();
    final String field = type == RecomendationType.book
        ? 'lastSuggestedBooks'
        : 'lastSuggestedMovies';

    await _firestore
        .collection(_userCollection)
        .doc(userId)
        .update({field: recomendations});
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
