import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recomendiaa/providers/home_page_providers.dart';

class PageDotIndicators extends ConsumerWidget {
  const PageDotIndicators({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(homeViewModelProvider).currentIndex;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 8,
          width: 8,
          decoration: BoxDecoration(
            color: currentIndex == 0
                ? Colors.white
                : Colors.white.withOpacity(0.4),
            shape: BoxShape.circle,
          ),
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 8,
          width: 8,
          decoration: BoxDecoration(
            color: currentIndex == 1
                ? Colors.white
                : Colors.white.withOpacity(0.4),
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }
}
