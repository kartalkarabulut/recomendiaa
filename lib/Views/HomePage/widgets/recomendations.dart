import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recomendiaa/Views/HomePage/widgets/recomended_book_widget.dart';
import 'package:recomendiaa/Views/HomePage/widgets/recomended_movie_widget.dart';
import 'package:recomendiaa/core/constants/app_constans.dart';
import 'package:recomendiaa/providers/home_page_providers.dart';
import 'package:recomendiaa/providers/user_data_providers.dart';

class Recomendations extends ConsumerWidget {
  const Recomendations({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userData = ref.watch(userDataProvider);
    final currentIndex = ref.watch(homeViewModelProvider).currentIndex;

    return SizedBox(
      height: AppConstants.screenHeight(context) * 0.6,
      child: PageView(
        // controller: _pageController,

        onPageChanged: (index) {
          ref.read(homeViewModelProvider.notifier).setCurrentIndex(index);
        },
        children: [
          // Movies Page
          userData.when(
            data: (data) => ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: data?.lastSuggestedMovies.length ?? 0,
              itemBuilder: (context, index) => RecomendedMovie(
                movie: data!.lastSuggestedMovies[index],
              ),
            ),
            error: (error, stack) => Text(error.toString()),
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
          ),

          // Books Page
          userData.when(
            data: (data) => ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: data?.lastSuggestedBooks.length ?? 0,
              itemBuilder: (context, index) => RecomendedBook(
                book: data!.lastSuggestedBooks[index],
              ),
            ),
            error: (error, stack) => Text(error.toString()),
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ],
      ),
    );
  }
}
