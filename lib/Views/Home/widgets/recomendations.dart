import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recomendiaa/Views/Home/widgets/recomended_book_widget.dart';
import 'package:recomendiaa/Views/Home/widgets/recomended_movie_widget.dart';
import 'package:recomendiaa/core/theme/styles/app_text_styles.dart';
import 'package:recomendiaa/providers/home_page_providers.dart';
import 'package:recomendiaa/providers/user_data_providers.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Recomendations extends ConsumerWidget {
  const Recomendations({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userData = ref.watch(userDataProvider);

    return SizedBox(
      height: 380,
      child: PageView(
        onPageChanged: (index) {
          ref.read(homeViewModelProvider.notifier).setCurrentIndex(index);
        },
        children: [
          // Movies Page
          userData.when(
            data: (data) => ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: data?.lastSuggestedMovies.length ?? 0,
              itemBuilder: (context, index) => RecomendedMovie(
                movie: data!.lastSuggestedMovies[index],
                isSmartSuggestion: true,
              ),
            ),
            error: (error, stack) => Center(
              child: Text(
                AppLocalizations.of(context)!.refreshThePage,
                style: AppTextStyles.largeTextStyle.copyWith(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
          ),

          // Books Page
          userData.when(
            data: (data) => ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: data?.lastSuggestedBooks.length ?? 0,
              itemBuilder: (context, index) => RecomendedBook(
                book: data!.lastSuggestedBooks[index],
                isSmartSuggestion: true,
              ),
            ),
            error: (error, stack) => Center(
              child: Text(
                AppLocalizations.of(context)!.refreshThePage,
                style: AppTextStyles.largeTextStyle.copyWith(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ],
      ),
    );
  }
}
