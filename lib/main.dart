import 'package:flutter/material.dart';
import 'package:recomendiaa/app/auth_wigdet.dart';
import 'package:recomendiaa/core/theme/light_theme.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:recomendiaa/models/book_recomendation_model.dart';
import 'package:recomendiaa/models/movie_recomendation_model.dart';
import 'firebase_options.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:hive/hive.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Hive.initFlutter();
  Hive.registerAdapter(MovieRecomendationModelAdapter());
  Hive.registerAdapter(BookRecomendationModelAdapter());

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // localizationsDelegates: const [
      //   GlobalMaterialLocalizations.delegate,
      //   GlobalWidgetsLocalizations.delegate,
      //   GlobalCupertinoLocalizations.delegate,
      // ],
      // supportedLocales: const [
      //   Locale('en'),
      //   Locale('tr'),
      // ],
      locale: const Locale('tr'),
      title: 'Flutter Demo',
      theme: lightTheme,
      home: const AuthWidget(),
    );
  }
}
