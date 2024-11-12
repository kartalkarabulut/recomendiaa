import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recomendiaa/SharedViews/shared_snackbars.dart';
import 'package:recomendiaa/Views/HomePage/widgets/dot_indicator.dart';
import 'package:recomendiaa/Views/HomePage/widgets/recomendation_type_widget.dart';
import 'package:recomendiaa/Views/HomePage/widgets/recomendation_types_row.dart';
import 'package:recomendiaa/Views/HomePage/widgets/recomendations.dart';
import 'package:recomendiaa/Views/HomePage/widgets/recomended_book_widget.dart';
import 'package:recomendiaa/Views/HomePage/widgets/recomended_movie_widget.dart';
import 'package:recomendiaa/Views/HomePage/widgets/suggestion_selector.dart';
import 'package:recomendiaa/Views/Profile/profile_view.dart';
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
          Positioned.fill(
            child: RefreshIndicator(
              // strokeWidth: 5,
              edgeOffset: 100,

              triggerMode: RefreshIndicatorTriggerMode.onEdge,
              displacement: 100,
              semanticsLabel: "Refresh",
              semanticsValue: "Refreshing",
              onRefresh: () async {
                SharedSnackbars.showInfoSnackBar(
                    context, "Refresh can take a while");
                await ref
                    .read(homeViewModelProvider.notifier)
                    .generateMovieBookSuggestion(ref);
              },
              backgroundColor: AppColors.darkBackgorind,
              color: Colors.deepOrange,
              child: Padding(
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
                            .copyWith(fontSize: 25),
                      ),
                      actions: [
                        IconButton(
                            onPressed: () async {
                              // await FirebaseAuth.instance.signOut();
                              // ref.invalidate(userDataProvider);
                              // ref.invalidate(userIdProvider);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const ProfileView(),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.person,
                              color: Colors.black,
                              size: 40,
                            ))
                      ],
                    ),
                    SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          const RecomendationTypesRow(),
                          const SizedBox(height: 40),
                          Text(
                            "Smart Suggestions",
                            style: AppTextStyles.xLargeTextStyle.copyWith(
                                // fontWeight: FontWeight.bold,
                                ),
                          ),
                          // const PageIndicators(),
                          const PageDotIndicators(),
                          const Recomendations(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
