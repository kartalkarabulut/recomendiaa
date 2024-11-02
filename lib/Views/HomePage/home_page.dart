import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recomendiaa/Views/HomePage/widgets/recomendation_type_widget.dart';
import 'package:recomendiaa/Views/HomePage/widgets/recomended_book_widget.dart';
import 'package:recomendiaa/Views/HomePage/widgets/recomended_movie_widget.dart';
import 'package:recomendiaa/Views/HomePage/widgets/suggestion_selector.dart';
import 'package:recomendiaa/Views/RecomendationViews/book-recomendation/book_recomendation_view.dart';
import 'package:recomendiaa/Views/RecomendationViews/movie-recomendation/movie_recomendation_view.dart';
import 'package:recomendiaa/core/constants/app_constans.dart';
import 'package:recomendiaa/core/theme/colors/app_colors.dart';
import 'package:recomendiaa/core/theme/styles/app_text_styles.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:recomendiaa/core/theme/colors/gradient_colors.dart';
import 'package:recomendiaa/providers/home_page_providers.dart';
import 'package:recomendiaa/providers/user_data_providers.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  TextEditingController promptController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    //   print("PostFrameCallback çalıştı");
    //   // 3 saniyelik gecikme eklendi
    //   await Future.delayed(const Duration(seconds: 1));
    //   try {
    //     await generateSuggestion();
    //     print("generateSuggestion tamamlandı");
    //   } catch (e) {
    //     print("generateSuggestion hatası: $e");
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(homeViewModelProvider);
    final userData = ref.watch(userDataProvider);

    return Scaffold(
      backgroundColor: AppColors.darkBackgorind,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                gradient: AppGradientColors.primaryGradient,
                backgroundBlendMode: BlendMode.lighten),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 0),
              child: Container(color: Colors.black.withOpacity(0.75)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  floating: true,
                  // excludeHeaderSemantics: true,
                  pinned: true,
                  // snap: true,
                  backgroundColor: Colors.transparent,
                  expandedHeight: 80,
                  centerTitle: true,
                  title: Text(
                    "Recomendia",
                    style: AppTextStyles.orbitronlargeTextStyle
                        .copyWith(fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                  actions: [
                    IconButton(
                        onPressed: () async {
                          await FirebaseAuth.instance.signOut();
                          ref.invalidate(userDataProvider);
                          ref.invalidate(userIdProvider);
                        },
                        icon: Icon(
                          Icons.person,
                          color: Colors.black,
                          size: 40,
                        ))
                  ],
                  //   title: Text(
                  //     "Recomendia",
                  //     style: AppTextStyles.orbitronlargeTextStyle
                  //         .copyWith(fontWeight: FontWeight.bold),
                  //   ),
                  //   centerTitle: true,
                  // ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RecomendationTypeWidget(
                            width: AppConstants.screenWidth(context) * 0.4,
                            imagePath: "movie.png",
                            title: "Film Önerisi",
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const MovieRecomendationView(),
                                ),
                              );
                            },
                          ),
                          RecomendationTypeWidget(
                            width: AppConstants.screenWidth(context) * 0.4,
                            imagePath: "book-stack.png",
                            title: "Kitap Önerisi",
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const BookRecomendationView(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // IconButton(
                      //     onPressed: () async {
                      //       // await FirebaseAuth.instance.signOut();
                      //       // ref.invalidate(userDataProvider);
                      //       // ref.invalidate(userIdProvider);
                      //       generateSuggestion();
                      //     },
                      //     icon: const Icon(Icons.logout)),
                      Text(
                        "Special For You",
                        style: AppTextStyles.xLargeTextStyle.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // const SuggestionSelector()
                      SuggestionSelector(
                          onSelectionChanged: (isMovieSelected) {
                            ref
                                .read(homeViewModelProvider.notifier)
                                .toggleMoviesSelection();
                          },
                          isFirstSelected: homeState.isMoviesSelected),
                      // const SizedBox(height: 2),
                      userData.when(
                        data: (data) {
                          if (homeState.isMoviesSelected) {
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return RecomendedMovie(
                                  movie: data!.lastSuggestedMovies[index],
                                );
                              },
                              itemCount: data!.lastSuggestedMovies.length,
                            );
                          } else {
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return RecomendedBook(
                                  book: data!.lastSuggestedBooks[index],
                                );
                              },
                              itemCount: data!.lastSuggestedBooks.length,
                            );
                          }
                        },
                        error: (error, stack) => Text(error.toString()),
                        loading: () => const Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
