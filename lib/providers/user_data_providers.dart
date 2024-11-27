import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recomendiaa/models/user_model.dart';
import 'package:recomendiaa/services/user/data/from-firestore/user_data_from_firestore_imp.dart';

final userDataServiceProvider = Provider<UserDataFromFirestoreImp>((ref) {
  return UserDataFromFirestoreImp();
});

final userDataProvider = FutureProvider<UserModel?>((ref) async {
  final userId = ref.read(userIdProvider);
  final userDataService = ref.watch(userDataServiceProvider);
  print("Kullanıcı ID'si: $userId");

  print("userdata provider çalıştı");
  return await userDataService.getUserData(userId!);
});

final userIdProvider = Provider<String?>((ref) {
  final userId = FirebaseAuth.instance.currentUser?.uid;
  print("Kullanıcı ID'si: $userId");
  return userId;
});

final authStateProvider = StreamProvider((ref) {
  return FirebaseAuth.instance.authStateChanges();
});
