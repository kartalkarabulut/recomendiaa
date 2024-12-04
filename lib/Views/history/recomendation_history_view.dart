import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recomendiaa/Views/history/widgets/books_listview.dart';
import 'package:recomendiaa/Views/history/widgets/movies_listview.dart';
import 'package:recomendiaa/Views/history/widgets/navigation_button.dart';
import 'package:recomendiaa/core/theme/colors/gradient_colors.dart';
import 'package:recomendiaa/core/theme/styles/app_text_styles.dart';
import 'package:recomendiaa/providers/recm_history_providers.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RecomendationHistory extends ConsumerStatefulWidget {
  const RecomendationHistory({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _RecomendationHistoryState();
}

class _RecomendationHistoryState extends ConsumerState<RecomendationHistory> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final recomendationHistoryViewModel =
        ref.watch(recomendationHistoryViewModelProvider);
    if (_pageController.hasClients &&
        _pageController.page?.round() !=
            recomendationHistoryViewModel.currentIndex) {
      _pageController.animateToPage(recomendationHistoryViewModel.currentIndex,
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: AppGradientColors.primaryGradient,
                backgroundBlendMode: BlendMode.lighten,
              ),
            ),
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 0),
                child: Container(color: Colors.black.withOpacity(0.75)),
              ),
            ),
            Column(
              children: [
                SizedBox(
                  height: 80,
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context)!.recomendationHistory,
                      style: AppTextStyles.orbitronlargeTextStyle.copyWith(
                        fontSize: 24,
                      ),
                    ),
                  ),
                ),

                // Navigation Buttons
                const HistoryNavigationButtons(),

                // PageView
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (index) {
                      ref
                          .read(recomendationHistoryViewModelProvider.notifier)
                          .setCurrentIndex(index);
                    },
                    children: const [
                      // Movies Page
                      MoviesListView(),

                      // Books Page
                      BooksListView(),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
