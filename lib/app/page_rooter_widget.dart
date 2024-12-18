import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recomendiaa/Views/Home/home_page.dart';
import 'package:recomendiaa/Views/history/recomendation_history_view.dart';
import 'package:recomendiaa/core/constants/app_constans.dart';
import 'package:recomendiaa/core/theme/colors/app_colors.dart';
import 'package:recomendiaa/core/theme/colors/gradient_colors.dart';
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
        bottomNavigationBar: Container(
          height: AppConstants.screenHeight(context) * 0.1,
          decoration: BoxDecoration(color: Colors.black.withOpacity(0.1)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                  onPressed: () {
                    ref.read(pageIndexProvider.notifier).state = 0;
                  },
                  icon: Image.asset(
                    "assets/logos/home.png",
                    height: 40,
                    width: 40,
                    color: pageIndex == 0
                        ? AppColors.yellowGreenColor
                        : Colors.white.withOpacity(0.5),
                  )),
              IconButton(
                  onPressed: () {
                    ref.read(pageIndexProvider.notifier).state = 1;
                  },
                  icon: Image.asset(
                    "assets/logos/history.png",
                    height: 40,
                    width: 40,
                    color: pageIndex == 1
                        ? AppColors.yellowGreenColor
                        : Colors.white.withOpacity(0.5),
                  )),
            ],
          ),
        )
        // BottomNavigationBar(
        //   backgroundColor: AppColors.darkBackgorind.withOpacity(0.9),
        //   currentIndex: pageIndex,
        //   elevation: 8, // Gölge efekti
        //   selectedItemColor: Colors.white, // Seçili öğe rengi
        //   unselectedItemColor:
        //       Colors.white.withOpacity(0.6), // Seçili olmayan öğe rengi
        //   selectedLabelStyle: const TextStyle(
        //     fontWeight: FontWeight.bold,
        //     fontSize: 14,
        //   ),
        //   type: BottomNavigationBarType.fixed, // Sabit genişlik
        //   onTap: (index) {
        //     ref.read(pageIndexProvider.notifier).state = index;
        //   },
        //   items: const [
        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.home_rounded), // Yuvarlak köşeli icon
        //       activeIcon:
        //           Icon(Icons.home_rounded, size: 28), // Seçili durumda büyük icon
        //       label: 'Home',
        //     ),
        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.history_rounded), // Yuvarlak köşeli icon
        //       activeIcon: Icon(Icons.history_rounded,
        //           size: 28), // Seçili durumda büyük icon
        //       label: 'History',
        //     ),
        //   ],
        // ),
        );
  }
}

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
//       bottomNavigationBar: CustomBottomNavigationBar(
//         currentIndex: pageIndex,
//         onTap: (index) {
//           ref.read(pageIndexProvider.notifier).state = index;
//         },
//       ),
//     );
//   }
// }

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
    return NavigationBarContainer(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          NavigationItem(
            isSelected: currentIndex == 0,
            onTap: () => onTap(0),
            iconPath: "assets/logos/home.png",
            label: 'Home',
          ),
          NavigationItem(
            isSelected: currentIndex == 1,
            onTap: () => onTap(1),
            iconPath: "assets/logos/history.png",
            label: 'History',
          ),
        ],
      ),
    );
  }
}

class NavigationBarContainer extends StatelessWidget {
  final Widget child;

  const NavigationBarContainer({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppConstants.screenHeight(context) * 0.08,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        // color: AppColors.darkBackgorind.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        // border: Border.all(
        //   color: Colors.white.withOpacity(0.1),
        //   width: 0.5,
        // ),
      ),
      child: child,
    );
  }
}

class NavigationItem extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onTap;
  final String iconPath;
  final String label;

  const NavigationItem({
    Key? key,
    required this.isSelected,
    required this.onTap,
    required this.iconPath,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: isSelected
              ? AppColors.yellowGreenColor.withOpacity(0.2)
              : Colors.transparent,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
                onPressed: onTap,
                icon: Image.asset(
                  color: isSelected
                      ? AppColors.yellowGreenColor
                      : Colors.white.withOpacity(0.5),
                  iconPath,
                  height: 30,
                  width: 30,
                )),
            // Icon(
            //   icon,
            //   size: 24,
            //   color: isSelected
            //       ? AppColors.yellowGreenColor
            //       : Colors.white.withOpacity(0.5),
            // ),
            // const SizedBox(height: 4),
            // Text(
            //   label,
            //   style: TextStyle(
            //     color: isSelected
            //         ? AppColors.yellowGreenColor
            //         : Colors.white.withOpacity(0.5),
            //     fontSize: 12,
            //     fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
