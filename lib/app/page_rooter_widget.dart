import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recomendiaa/Views/HomePage/home_page.dart';
import 'package:recomendiaa/Views/history/recomendation_history_view.dart';
import 'package:recomendiaa/core/theme/colors/app_colors.dart';
import 'package:recomendiaa/core/theme/colors/gradient_colors.dart';
import 'package:recomendiaa/providers/app_providers.dart';

// class PageRooter extends ConsumerWidget {
//   PageRooter({super.key});
//   List<Widget> pages = [
//     const HomePage(),
//     const RecomendationHistory(),
//   ];
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final pageIndex = ref.watch(pageIndexProvider);
//     return Scaffold(
//       body: pages[pageIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         backgroundColor: Colors.orange.withOpacity(0.5),
//         currentIndex: pageIndex,
//         elevation: 8, // Gölge efekti
//         selectedItemColor: Colors.white, // Seçili öğe rengi
//         unselectedItemColor:
//             Colors.white.withOpacity(0.6), // Seçili olmayan öğe rengi
//         selectedLabelStyle: const TextStyle(
//           fontWeight: FontWeight.bold,
//           fontSize: 14,
//         ),
//         type: BottomNavigationBarType.fixed, // Sabit genişlik
//         onTap: (index) {
//           ref.read(pageIndexProvider.notifier).state = index;
//         },
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home_rounded), // Yuvarlak köşeli icon
//             activeIcon:
//                 Icon(Icons.home_rounded, size: 28), // Seçili durumda büyük icon
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.history_rounded), // Yuvarlak köşeli icon
//             activeIcon: Icon(Icons.history_rounded,
//                 size: 28), // Seçili durumda büyük icon
//             label: 'History',
//           ),
//         ],
//       ),
//     );
//   }
// }
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
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: pageIndex,
        onTap: (index) {
          ref.read(pageIndexProvider.notifier).state = index;
        },
      ),
    );
  }
}

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;

  final ValueChanged<int> onTap;

  const CustomBottomNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          height: 80,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.yellowGreenColor.withOpacity(0.7),
                AppColors.greenyColor.withOpacity(0.7)
              ],
            ),
            border: Border(
              top: BorderSide(
                color: Colors.white.withOpacity(0.2),
                width: 0.5,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () => onTap(0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.home_rounded,
                      size: currentIndex == 0 ? 32 : 28,
                      color: currentIndex == 0
                          ? Colors.white
                          : Colors.white.withOpacity(0.6),
                    ),
                    const Text(
                      'Home',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => onTap(1),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.history_rounded,
                      size: currentIndex == 1 ? 32 : 28,
                      color: currentIndex == 1
                          ? Colors.white
                          : Colors.white.withOpacity(0.6),
                    ),
                    const Text(
                      'History',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
