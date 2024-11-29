import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recomendiaa/SharedViews/shared_snackbars.dart';
import 'package:recomendiaa/Views/Auth/auth_screen.dart';
import 'package:recomendiaa/Views/Home/widgets/dot_indicator.dart';
import 'package:recomendiaa/Views/Home/widgets/recomendation_types_row.dart';
import 'package:recomendiaa/Views/Home/widgets/recomendations.dart';
import 'package:recomendiaa/core/shared-funtcions/all_formatters.dart';
import 'package:recomendiaa/core/theme/colors/app_colors.dart';
import 'package:recomendiaa/core/theme/styles/app_text_styles.dart';
import 'package:recomendiaa/core/theme/colors/gradient_colors.dart';
import 'package:recomendiaa/providers/home_page_providers.dart';
import 'package:recomendiaa/providers/user_data_providers.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
              semanticsLabel: AppLocalizations.of(context)!.refresh,
              semanticsValue: AppLocalizations.of(context)!.refreshing,
              onRefresh: () async {
                SharedSnackbars.showInfoSnackBar(context,
                    AppLocalizations.of(context)!.refreshCanTakeAWhile);
                ref.invalidate(userIdProvider);
                ref.invalidate(userDataProvider);
                final language = Localizations.localeOf(context).languageCode;
                await ref
                    .read(homeViewModelProvider.notifier)
                    .generateMovieBookSuggestion(ref, language);
              },
              backgroundColor: AppColors.darkBackgorind,
              color: Colors.deepOrange,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      floating: true,
                      automaticallyImplyLeading: false,
                      // excludeHeaderSemantics: true,
                      pinned: true,
                      // snap: true,
                      backgroundColor: Colors.transparent,
                      // expandedHeight: 80,
                      centerTitle: true,
                      title: Text(
                        "Recomendia",
                        style: AppTextStyles.orbitronlargeTextStyle
                            .copyWith(fontSize: 25),
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          const UserInfoMenu(),
                          const RecomendationTypesRow(),
                          const SizedBox(height: 40),
                          Text(
                            AppLocalizations.of(context)!.smartSuggestions,
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

class UserInfoMenu extends ConsumerWidget {
  const UserInfoMenu({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userDataAsync = ref.watch(userDataProvider);

    return userDataAsync.when(
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stackTrace) => Center(
        child: Text(
          AppLocalizations.of(context)!.errorOccurred(error.toString()),
          style: AppTextStyles.mediumTextStyle.copyWith(
            color: Colors.red,
          ),
        ),
      ),
      data: (userData) => Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userData?.fullName != null && userData!.fullName.isNotEmpty
                        ? AllFormatters.capitalizeEachWord(userData.fullName)
                        : AppLocalizations.of(context)!.nameNotProvided,
                    style: AppTextStyles.largeTextStyle
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    userData?.email != null && userData!.email.isNotEmpty
                        ? userData.email
                        : AppLocalizations.of(context)!.emailNotProvided,
                    style: AppTextStyles.mediumTextStyle
                        .copyWith(color: Colors.grey),
                  ),
                ],
              ),
            ),
            PopupMenuButton(
              icon: const Icon(Icons.more_vert, color: Colors.white),
              color: AppColors.darkBackgorind,
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: Row(
                    children: [
                      const Icon(Icons.logout, color: Colors.white),
                      const SizedBox(width: 8),
                      Text(AppLocalizations.of(context)!.logout,
                          style: AppTextStyles.mediumTextStyle),
                    ],
                  ),
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    ref.invalidate(userDataProvider);
                    ref.invalidate(userIdProvider);
                    ref.invalidate(authStateProvider);
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AuthView()));
                  },
                ),
                PopupMenuItem(
                  child: Row(
                    children: [
                      const Icon(Icons.delete, color: Colors.red),
                      const SizedBox(width: 8),
                      Text(AppLocalizations.of(context)!.deleteAccount,
                          style: AppTextStyles.mediumTextStyle
                              .copyWith(color: Colors.red)),
                    ],
                  ),
                  onTap: () async {
                    try {
                      final user = FirebaseAuth.instance.currentUser;
                      if (user != null) {
                        // Firestore'daki kullanıcı verilerini sil
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(user.uid)
                            .delete();

                        // Firebase Auth'daki kullanıcıyı sil
                        await user.delete();

                        // Provider'ları sıfırla
                        ref.invalidate(userDataProvider);
                        ref.invalidate(userIdProvider);
                        ref.invalidate(authStateProvider);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AuthView()));
                      }
                    } catch (e) {
                      print(e);
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
