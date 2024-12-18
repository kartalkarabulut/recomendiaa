import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recomendiaa/Views/Auth/login/login_view.dart';
import 'package:recomendiaa/Views/Auth/Introduction/introduction_screen.dart';
import 'package:recomendiaa/core/theme/colors/app_colors.dart';
import 'package:recomendiaa/core/theme/colors/gradient_colors.dart';
import 'package:recomendiaa/core/theme/styles/app_text_styles.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AuthView extends ConsumerWidget {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenHeight = MediaQuery.of(context).size.height;

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
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  // Üst Boşluk
                  SizedBox(height: screenHeight * 0.1),

                  // Logo ve Başlık Bölümü
                  Column(
                    children: [
                      // Logo Animasyonu
                      TweenAnimationBuilder(
                        tween: Tween<double>(begin: 0, end: 1),
                        duration: const Duration(milliseconds: 1000),
                        builder: (context, value, child) {
                          return Transform.scale(
                            scale: value,
                            child: Text(
                              'Recomendia',
                              style:
                                  AppTextStyles.orbitronlargeTextStyle.copyWith(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    color:
                                        AppColors.primary100.withOpacity(0.5),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 16),

                      // Alt Başlık
                      Text(
                        AppLocalizations.of(context)!
                            .yourPersonalMovieAndBookRecommendationAssistant,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.largeTextStyle.copyWith(
                          height: 1.5,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  // Alt Bölüm - Butonlar
                  Column(
                    children: [
                      Text(
                        AppLocalizations.of(context)!
                            .promiseItWillNotTakeTooLong,
                        style: AppTextStyles.mediumTextStyle.copyWith(
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Başlangıç Butonu
                      Container(
                        width: double.infinity,
                        height: 65,
                        decoration: BoxDecoration(
                          // gradient: AppGradientColors.primaryGradient,
                          color: Colors.deepOrange,
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const IntroductionPageView(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            AppLocalizations.of(context)!.getStarted,
                            style: AppTextStyles.largeTextStyle.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Giriş Yap Linki
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const LoginView()),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.white.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                          ),
                          child: RichText(
                            text: TextSpan(
                              style: AppTextStyles.mediumTextStyle.copyWith(
                                color: Colors.white.withOpacity(0.9),
                              ),
                              children: [
                                TextSpan(
                                  text: AppLocalizations.of(context)!
                                      .alreadyHaveAnAccount,
                                ),
                                TextSpan(
                                  text: AppLocalizations.of(context)!.login,
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.deepOrange,
                                    // decoration: TextDecoration.underline,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.05),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
