import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recomendiaa/Views/Auth/auth_screen.dart';
import 'package:recomendiaa/Views/Auth/login/login_view.dart';
import 'package:recomendiaa/Views/Auth/register/register_view.dart';
import 'package:recomendiaa/core/constants/app_constans.dart';
import 'package:recomendiaa/core/theme/colors/gradient_colors.dart';
import 'package:recomendiaa/core/theme/styles/app_text_styles.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class IntroductionScreen extends ConsumerWidget {
  const IntroductionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                gradient: AppGradientColors.primaryGradient,
                backgroundBlendMode: BlendMode.lighten),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
              child: Container(color: Colors.black.withOpacity(0.4)),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // const SizedBox(
              //   height: 50,
              // ),
              Image.asset(
                "assets/images/people.png",
                width: AppConstants.screenWidth(context),
                height: AppConstants.screenHeight(context) * 0.4,
              ),
              // const SizedBox(
              //   height: 100,
              // ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  "Book recommendations based on your own interests and preferences, tailored perfectly for you!",
                  textAlign: TextAlign.center,
                  style: AppTextStyles.xLargeTextStyle
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class IntroductionScreen2 extends ConsumerWidget {
  const IntroductionScreen2({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                gradient: AppGradientColors.primaryGradient,
                backgroundBlendMode: BlendMode.lighten),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
              child: Container(color: Colors.black.withOpacity(0.4)),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // const SizedBox(
              //   height: 50,
              // ),
              Image.asset(
                "assets/images/movie-full-stack.png",
                width: AppConstants.screenWidth(context),
              ),
              // const SizedBox(
              //   height: 50,
              // ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  "Movie recommendations based on your own interests and preferences, tailored perfectly for you!",
                  textAlign: TextAlign.center,
                  style: AppTextStyles.largeTextStyle
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              // const Spacer(),
              // const SizedBox(
              //   height: 100,
              // ),
              // const Spacer(),
              // CustomButton(text: "Next", onPressed: () {})
            ],
          ),
        ],
      ),
    );
  }
}

class IntroductionPageView extends ConsumerStatefulWidget {
  const IntroductionPageView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _IntroductionPageViewState();
}

class _IntroductionPageViewState extends ConsumerState<IntroductionPageView> {
  final PageController _pageController = PageController();
  bool isLastPage = false;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppGradientColors.primaryGradient,
          backgroundBlendMode: BlendMode.lighten,
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 0),
                child: Container(color: Colors.black.withOpacity(0.4)),
              ),
            ),
            Column(
              children: [
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    scrollDirection: Axis.horizontal,
                    onPageChanged: (index) {
                      setState(() {
                        isLastPage = index == 1;
                      });
                    },
                    children: const [
                      IntroductionScreen(),
                      IntroductionScreen2(),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 50, left: 20, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SmoothPageIndicator(
                        controller: _pageController,
                        count: 2,
                        effect: WormEffect(
                          dotColor: Colors.grey.shade400,
                          activeDotColor: Colors.white,
                          dotHeight: 10,
                          dotWidth: 10,
                          spacing: 8,
                        ),
                      ),
                      if (isLastPage)
                        const SizedBox(
                          width: 50,
                        ),
                      if (isLastPage)
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RegisterView(),
                              ),
                            );
                          },
                          child: const Text(
                            'Next',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
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
      ),
    );
  }
}
