import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recomendiaa/core/constants/app_constans.dart';
import 'package:recomendiaa/core/theme/colors/app_colors.dart';
import 'package:recomendiaa/core/theme/styles/app_text_styles.dart';
import 'package:recomendiaa/providers/home_page_providers.dart';

class SuggestionSelector extends ConsumerWidget {
  const SuggestionSelector({
    super.key,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeViewModelProvider);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 70,
          width: AppConstants.screenWidth(context) * 0.65,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          decoration: BoxDecoration(
              color: AppColors.darkBackgorind.withOpacity(0.6),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    ref
                        .read(homeViewModelProvider.notifier)
                        .toggleMoviesSelection();
                  },
                  child: Text(
                    "Movies",
                    style: AppTextStyles.xLargeTextStyle.copyWith(
                        color: homeState.isMoviesSelected
                            ? Colors.white
                            : Colors.grey),
                  ),
                ),
                const SizedBox(width: 10),
                const VerticalDivider(
                  thickness: 2,
                  width: 10,
                  color: Colors.white,
                ),
                const SizedBox(width: 10),
                TextButton(
                  onPressed: () {
                    ref
                        .read(homeViewModelProvider.notifier)
                        .toggleMoviesSelection();
                  },
                  child: Text(
                    "Books",
                    style: AppTextStyles.xLargeTextStyle.copyWith(
                      fontWeight: !homeState.isMoviesSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: !homeState.isMoviesSelected
                          ? Colors.white
                          : Colors.grey,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
