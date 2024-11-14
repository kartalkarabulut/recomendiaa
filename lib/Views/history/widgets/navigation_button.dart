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
              imageName: "movieNav.png",
              title: 'Movies',
              isSelected: currentPage == 0,
              onPressed: () {
                viewModel.setCurrentIndex(0);
              },
            ),
          ),
          Expanded(
            child: NavigationButton(
              imageName: "book-stack.png",
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
    required this.imageName,
    super.key,
  });

  final bool isSelected;
  final VoidCallback onPressed;
  final String title;
  final String imageName;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      padding: const EdgeInsets.all(10),
      duration: const Duration(milliseconds: 300),
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          decoration: BoxDecoration(
            color:
                isSelected ? Colors.white.withOpacity(0.2) : Colors.transparent,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.white70,
                ),
              ),
              IconButton(
                  iconSize: 10,
                  onPressed: null,
                  icon: Image.asset(
                    "assets/images/$imageName",
                    fit: BoxFit.fill,
                    width: 20,
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
