import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recomendiaa/Views/Auth/login/login_view.dart';
import 'package:recomendiaa/Views/Auth/registration/registration_view.dart';
import 'package:recomendiaa/Views/Auth/widgets/or_text.dart';
import 'package:recomendiaa/core/constants/app_constans.dart';
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
                backgroundBlendMode: BlendMode.lighten),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(color: Colors.black.withOpacity(0.75)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 250,
                  height: 250,
                  child: Image.asset(
                    fit: BoxFit.cover,
                    'assets/logos/logo.png',
                    // width: 250,
                    // height: 250,
                  ),
                ),
                // const SizedBox(height: 20),
                Text(
                  'Recomendia',
                  style: AppTextStyles.orbitronlargeTextStyle
                      .copyWith(fontSize: 40),
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.start,
                //   children: [
                //     Text(
                //       "Let's Get Started",
                //       style: AppTextStyles.largeTextStyle
                //           .copyWith(fontSize: 20, fontWeight: FontWeight.bold),
                //     ),
                //   ],
                // ),
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Already have an account?',
                      style: AppTextStyles.largeTextStyle
                          .copyWith(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                CustomButton(
                  text: "Login",
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginView()));
                  },
                ),
                const SizedBox(height: 20),
                const OrText(),
                const SizedBox(height: 20),
                CustomButton(
                  text: "Sign Up",
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RegistrationView()));
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
