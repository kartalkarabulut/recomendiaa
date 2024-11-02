import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recomendiaa/models/user_model.dart';
import 'package:recomendiaa/services/user/data/from-firestore/user_data_from_firestore_imp.dart';

final userDataProvider = FutureProvider<UserModel?>((ref) async {
  final userId = ref.watch(userIdProvider);
  print("userdata provider çalıştı");
  return UserDataFromFirestoreImp().getUserData(userId!);
});

final userIdProvider = Provider<String?>((ref) {
  return FirebaseAuth.instance.currentUser?.uid;
});

final authStateProvider = StreamProvider((ref) {
  return FirebaseAuth.instance.authStateChanges();
});
