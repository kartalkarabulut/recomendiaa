import 'package:flutter/material.dart';
import 'package:recomendiaa/app/auth_wigdet.dart';
import 'package:recomendiaa/app/main_initializations.dart';
import 'package:recomendiaa/core/theme/light_theme.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:hive/hive.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MainInitializations.allInitializations();
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
