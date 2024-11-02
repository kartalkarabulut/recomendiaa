import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recomendiaa/Views/HomePage/home_page.dart';
import 'package:recomendiaa/Views/history/recomendation_history.dart';
import 'package:recomendiaa/providers/app_providers.dart';

class PageRooter extends ConsumerWidget {
  PageRooter({super.key});
  List<Widget> pages = [
    const HomePage(),
    const RecomendationHistory(),
  ];
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageIndex = ref.watch(pageIndexProvider);
    return Scaffold(
      body: pages[pageIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: pageIndex,
        onTap: (index) {
          ref.read(pageIndexProvider.notifier).state = index;
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
        ],
      ),
    );
  }
}
