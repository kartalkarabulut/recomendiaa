import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recomendiaa/Views/Auth/login/login_view.dart';
import 'package:recomendiaa/Views/Home/widgets/prompt_field.dart';
import 'package:recomendiaa/Views/RecomendationViews/widgets/prompt_card.dart';
import 'package:recomendiaa/core/theme/colors/gradient_colors.dart';
import 'package:recomendiaa/core/theme/styles/app_text_styles.dart';
import 'package:recomendiaa/providers/book_providers.dart';
import 'package:recomendiaa/repository/recomendation_repository.dart';
import 'package:recomendiaa/services/ad-services/ads_services.dart';

import '../../../providers/user_data_providers.dart';

class BookRecomendationView extends ConsumerStatefulWidget {
  const BookRecomendationView({super.key});

  @override
  ConsumerState<BookRecomendationView> createState() =>
      _BookRecomendationViewState();
}

class _BookRecomendationViewState extends ConsumerState<BookRecomendationView> {
  late TextEditingController promptController;
  final NewAdService addServices = NewAdService();
  bool isInterstitialAdReady = false;

  @override
  void initState() {
    super.initState();
    promptController = TextEditingController();
    // AdServices().loadInterstitialAd(() {
    //   setState(() {});
    // });
    addServices.loadInterstitialAd();
  }

  @override
  void dispose() {
    promptController.dispose();
    super.dispose();
  }

  void loadInterstitialAd() {
    addServices.loadInterstitialAd();
  }

  void showInterstitialAd() {
    if (isInterstitialAdReady) {
      addServices.showInterstitialAd();
      isInterstitialAdReady = false;
      //reklam kapantıktan sonra yeni bir reklam yükleme  k için
      loadInterstitialAd();
    }
  }

  @override
  Widget build(BuildContext context) {
    final userData = ref.watch(userDataProvider);
    final bookRecomendationRepository =
        ref.read(bookRecomendationRepositoryProvider);
    final state = ref.watch(bookRecomendationViewModelProvider);
    final bookRecomendationViewModel =
        ref.read(bookRecomendationViewModelProvider.notifier);
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
          Column(
            children: [
              // const SizedBox(height: 100),
              // ElevatedButton(
              //     onPressed: () async {
              //       print("reklam gösterme denemeis");
              //       addServices.showInterstitialAd();
              //       // addServices.loadInterstitialAd(() {
              //       //   if (mounted) setState(() {});
              //       // });
              //       // await AdServices().showInterstitialAd(() {
              //       //   setState(() {});
              //       // });
              //     },
              //     child: Text("Show Ad")),
              SizedBox(
                height: 80,
                child: Center(
                  child: Text(
                    "Book Recomendation",
                    style: AppTextStyles.orbitronlargeTextStyle
                        .copyWith(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              PromptField(
                  promptController: promptController,
                  hintText: "Tell us about your taste in books"),

              const SizedBox(height: 30),
              userData.when(
                data: (data) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: SizedBox(
                      height: 120,
                      child: PromptScrollView(
                        prompts: data!.lastSuggestedBookPrompts,
                        promptController: promptController,
                      ),
                    ),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(child: Text('Hata: $error')),
              ),
              const Spacer(),
              CustomButton(
                text: "Suggest",
                onPressed: () {
                  bookRecomendationViewModel.handleSuggestButtonPress(
                    context: context,
                    ref: ref,
                    promptController: promptController,
                  );
                },
              )
            ],
          )
        ],
      ),
    );
  }
}
