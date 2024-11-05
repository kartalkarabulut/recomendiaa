import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recomendiaa/Views/HomePage/home_page.dart';
import 'package:recomendiaa/Views/history/recomendation_history.dart';
import 'package:recomendiaa/core/theme/colors/app_colors.dart';
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
        backgroundColor: Colors.orange.withOpacity(0.5),
        currentIndex: pageIndex,
        elevation: 8, // Gölge efekti
        selectedItemColor: Colors.white, // Seçili öğe rengi
        unselectedItemColor:
            Colors.white.withOpacity(0.6), // Seçili olmayan öğe rengi
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        type: BottomNavigationBarType.fixed, // Sabit genişlik
        onTap: (index) {
          ref.read(pageIndexProvider.notifier).state = index;
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded), // Yuvarlak köşeli icon
            activeIcon:
                Icon(Icons.home_rounded, size: 28), // Seçili durumda büyük icon
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_rounded), // Yuvarlak köşeli icon
            activeIcon: Icon(Icons.history_rounded,
                size: 28), // Seçili durumda büyük icon
            label: 'History',
          ),
        ],
      ),
    );
  }
}
