import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:recomendiaa/Views/Auth/register/register_view.dart';
import 'package:recomendiaa/core/theme/colors/app_colors.dart';
import 'package:recomendiaa/core/theme/colors/gradient_colors.dart';
import 'package:recomendiaa/core/theme/styles/app_text_styles.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class IntroductionPageView extends StatefulWidget {
  const IntroductionPageView({super.key});

  @override
  State<IntroductionPageView> createState() => _IntroductionPageViewState();
}

class _IntroductionPageViewState extends State<IntroductionPageView> {
  bool isLastPage = false;

  final PageController _pageController = PageController();

  List<IntroductionItem> getIntroItems(BuildContext context) {
    return [
      IntroductionItem(
          image: "assets/logos/mix2.png",
          description:
              AppLocalizations.of(context)!.findBooksAndMoviesThatSpeakToYou,
          gradientColors: [Colors.purple.shade700, Colors.blue.shade700],
          height: 0.5),
      IntroductionItem(
        image: "assets/images/man-wacthing.jpg",
        description:
            AppLocalizations.of(context)!.describeYourPerfectMovieScene,
        gradientColors: [Colors.orange.shade700, Colors.red.shade700],
      ),
      IntroductionItem(
        image: "assets/images/cantbook.jpg",
        description: AppLocalizations.of(context)!
            .justTellUsWhatKindOfBookYoureInTheMoodFor,
        gradientColors: [Colors.purple.shade700, Colors.blue.shade700],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final introItems = getIntroItems(context);
    return Scaffold(
      body: Stack(
        children: [
          // Arkaplan Gradient
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

          // Ana İçerik
          Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: introItems.length,
                  onPageChanged: (index) {
                    setState(() {
                      isLastPage = index == introItems.length - 1;
                    });
                  },
                  itemBuilder: (context, index) {
                    return IntroductionPage(item: introItems[index]);
                  },
                ),
              ),

              // Alt Kısım
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.06,
                  vertical: size.height * 0.02,
                ),
                child: Column(
                  children: [
                    // Sayfa Göstergesi
                    SmoothPageIndicator(
                      controller: _pageController,
                      count: introItems.length,
                      effect: ExpandingDotsEffect(
                        activeDotColor: AppColors.primary100,
                        dotColor: Colors.white.withOpacity(0.3),
                        dotHeight: 8,
                        dotWidth: 8,
                        spacing: 8,
                      ),
                    ),

                    SizedBox(height: size.height * 0.03),

                    // İleri/Başla Butonu
                    Container(
                      width: double.infinity,
                      height: 70,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.deepOrange, Colors.orange.shade700],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary100.withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          if (isLastPage) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const RegisterView()));
                          } else {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          isLastPage
                              ? AppLocalizations.of(context)!.letsStart
                              : AppLocalizations.of(context)!.continueButton,
                          style: AppTextStyles.largeTextStyle.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    if (!isLastPage)
                      Padding(
                        padding: EdgeInsets.only(top: size.height * 0.02),
                        child: TextButton(
                          onPressed: () {
                            _pageController.animateToPage(
                              introItems.length - 1,
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                            );
                          },
                          child: Text(
                            AppLocalizations.of(context)!.skip,
                            style: AppTextStyles.mediumTextStyle.copyWith(
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class IntroductionItem {
  IntroductionItem({
    required this.image,
    required this.description,
    required this.gradientColors,
    this.height,
  });
  double? height;
  final String description;
  final List<Color> gradientColors;
  final String image;
}

class IntroductionPage extends StatelessWidget {
  const IntroductionPage({
    super.key,
    required this.item,
  });

  final IntroductionItem item;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Görsel
          Container(
            height: size.height * (item.height ?? 0.4),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                item.image,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),

          const Spacer(),

          // Açıklama
          FittedBox(
            fit: BoxFit.scaleDown,
            child: SizedBox(
              width: size.width * 0.8,
              child: Text(
                item.description,
                style: AppTextStyles.mediumTextStyle.copyWith(
                  color: Colors.white.withOpacity(0.9),
                  height: 1.5,
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),

          const Spacer(flex: 2),
        ],
      ),
    );
  }
}
