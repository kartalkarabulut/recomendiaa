import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:recomendiaa/app/orientation_manager.dart';
import 'package:recomendiaa/firebase_options.dart';
import 'package:recomendiaa/models/book_recomendation_model.dart';
import 'package:recomendiaa/models/movie_recomendation_model.dart';

class MainInitializations {
  static Future<void> loadEnv() async {
    await dotenv.load(fileName: ".env");
  }

  static Future<void> initializeFirebase() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  }

  static Future<void> hiveInitializations() async {
    Hive.registerAdapter(MovieRecomendationModelAdapter());
    Hive.registerAdapter(BookRecomendationModelAdapter());

    await Hive.initFlutter();
  }

  static Future<void> lockOrientation() async {
    OrientationManager.lockPortrait();
  }

  static Future<void> allInitializations() async {
    await loadEnv();
    await initializeFirebase();
    await hiveInitializations();
    await lockOrientation();
  }
}
