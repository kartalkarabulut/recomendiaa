import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recomendiaa/Views/history/recomendation_history.dart';

class HistoryNavigationButtons extends ConsumerWidget {
  const HistoryNavigationButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPage =
        ref.watch(recomendationHistoryViewModelProvider).currentIndex;
    final viewModel = ref.read(recomendationHistoryViewModelProvider.notifier);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          Expanded(
            child: NavigationButton(
              title: 'Movies',
              isSelected: currentPage == 0,
              onPressed: () {
                viewModel.setCurrentIndex(0);
              },
            ),
          ),
          Expanded(
            child: NavigationButton(
              title: 'Books',
              isSelected: currentPage == 1,
              onPressed: () {
                viewModel.setCurrentIndex(1);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class NavigationButton extends StatelessWidget {
  const NavigationButton({
    required this.title,
    required this.isSelected,
    required this.onPressed,
    super.key,
  });

  final bool isSelected;
  final VoidCallback onPressed;
  final String title;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor:
              isSelected ? Colors.white.withOpacity(0.2) : Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white70,
          ),
        ),
      ),
    );
  }
}
