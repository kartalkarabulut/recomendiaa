import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recomendiaa/Views/Auth/login/login_view.dart';
import 'package:recomendiaa/Views/Auth/Introduction/introduction_screen.dart';
import 'package:recomendiaa/core/theme/colors/app_colors.dart';
import 'package:recomendiaa/core/theme/colors/gradient_colors.dart';
import 'package:recomendiaa/core/theme/styles/app_text_styles.dart';

class AuthView extends ConsumerWidget {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: AppGradientColors.primaryGradient,
              // color: AppColors.greenyColor,
              // backgroundBlendMode: BlendMode.lighten
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(color: Colors.black.withOpacity(0.75)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Center(
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Text(
                        'Recomendia',
                        style: AppTextStyles.orbitronlargeTextStyle
                            .copyWith(fontSize: 40),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Your personal movie and book recommendation assistant',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.largeTextStyle,
                      ),
                    ],
                  ),
                  // Spacer(),
                  Column(
                    children: [
                      Text(
                        "Promise it will not take too long",
                        style: AppTextStyles.mediumTextStyle.copyWith(
                          color: AppColors.whiteColor,
                        ),
                      ),
                      CustomButton(
                          text: "Get Started",
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const IntroductionPageView(),
                              ),
                            );
                          }),
                      const SizedBox(
                        height: 30,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const LoginView()),
                          );
                        },
                        child: Text(
                          "Already have an account? Login",
                          style: AppTextStyles.mediumTextStyle.copyWith(
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.white,
                              decorationStyle: TextDecorationStyle.solid,
                              decorationThickness: 1.5),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
