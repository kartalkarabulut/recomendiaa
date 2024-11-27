import 'package:flutter/material.dart';
import 'package:recomendiaa/core/constants/app_constans.dart';
import 'package:recomendiaa/core/theme/colors/app_colors.dart';
import 'package:recomendiaa/core/theme/styles/app_text_styles.dart';

class SuggestionSelector extends StatelessWidget {
  final Function(bool isFirstSelected) onSelectionChanged;
  final String firstTitle;
  final String secondTitle;
  final bool isFirstSelected;

  const SuggestionSelector({
    super.key,
    required this.onSelectionChanged,
    required this.isFirstSelected,
    this.firstTitle = "Movies",
    this.secondTitle = "Books",
  });

  @override
  Widget build(BuildContext context) {
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
                  onPressed: () => onSelectionChanged(true),
                  child: Text(
                    firstTitle,
                    style: AppTextStyles.xLargeTextStyle.copyWith(
                        color: isFirstSelected ? Colors.white : Colors.grey),
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
                  onPressed: () => onSelectionChanged(false),
                  child: Text(
                    secondTitle,
                    style: AppTextStyles.xLargeTextStyle.copyWith(
                      fontWeight: !isFirstSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: !isFirstSelected ? Colors.white : Colors.grey,
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
// class SuggestionSelector extends ConsumerWidget {
//   const SuggestionSelector({
//     super.key,
//   });
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final homeState = ref.watch(homeViewModelProvider);
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Container(
//           height: 70,
//           width: AppConstants.screenWidth(context) * 0.65,
//           padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//           decoration: BoxDecoration(
//               color: AppColors.darkBackgorind.withOpacity(0.6),
//               borderRadius: BorderRadius.all(Radius.circular(10))),
//           child: Center(
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 TextButton(
//                   onPressed: () {
//                     ref
//                         .read(homeViewModelProvider.notifier)
//                         .toggleMoviesSelection();
//                   },
//                   child: Text(
//                     "Movies",
//                     style: AppTextStyles.xLargeTextStyle.copyWith(
//                         color: homeState.isMoviesSelected
//                             ? Colors.white
//                             : Colors.grey),
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 const VerticalDivider(
//                   thickness: 2,
//                   width: 10,
//                   color: Colors.white,
//                 ),
//                 const SizedBox(width: 10),
//                 TextButton(
//                   onPressed: () {
//                     ref
//                         .read(homeViewModelProvider.notifier)
//                         .toggleMoviesSelection();
//                   },
//                   child: Text(
//                     "Books",
//                     style: AppTextStyles.xLargeTextStyle.copyWith(
//                       fontWeight: !homeState.isMoviesSelected
//                           ? FontWeight.bold
//                           : FontWeight.normal,
//                       color: !homeState.isMoviesSelected
//                           ? Colors.white
//                           : Colors.grey,
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
