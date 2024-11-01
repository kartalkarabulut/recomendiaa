import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recomendiaa/Views/Auth/login/login_view.dart';
import 'package:recomendiaa/Views/Auth/registration/registration_view_model.dart';
import 'package:recomendiaa/core/theme/colors/gradient_colors.dart';
import 'package:recomendiaa/repository/auth_repository.dart';

class RegistrationView extends ConsumerWidget {
  const RegistrationView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final registrationViewModel =
        ref.read(registrationViewModelProvider.notifier);
    bool isLoading = ref.watch(registrationViewModelProvider).isLoading;
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController fullNameController = TextEditingController();
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
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/logos/logo.png',
                    fit: BoxFit.cover,
                    width: 200,
                    height: 200,
                  ),
                  // const SizedBox(height: 20),
                  AuthField(
                    hintText: "Full Name",
                    controller: fullNameController,
                    iconPath: 'assets/logos/user.png',
                  ),
                  AuthField(
                    controller: emailController,
                    hintText: 'Email',
                    // icon: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  // const SizedBox(height: 20),
                  AuthField(
                    controller: passwordController,
                    hintText: 'Password',
                    isPassword: true,
                    iconPath: 'assets/images/password.png',
                    // icon: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 20),
                  CustomButton(
                      text: "Register",
                      onPressed: () async {
                        if (fullNameController.text.isNotEmpty &&
                            emailController.text.isNotEmpty &&
                            passwordController.text.isNotEmpty) {
                          await registrationViewModel.signUp(
                              emailController.text,
                              passwordController.text,
                              fullNameController.text,
                              SignUpType.emailPassword);
                        }
                      }),
                  const SizedBox(height: 20),
                  //   const GoogleSignIn(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
