import 'package:flutter/material.dart';
import 'package:recomendiaa/app/auth_wigdet.dart';
import 'package:recomendiaa/app/main_initializations.dart';
import 'package:recomendiaa/core/theme/light_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MainInitializations.allInitializations();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Recomendia',
      theme: lightTheme,
      home: const AuthWidget(),
    );
  }
}
