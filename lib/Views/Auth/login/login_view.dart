import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recomendiaa/Views/Auth/login/widgets/forgot_password.dart';
import 'package:recomendiaa/app/page_rooter_widget.dart';
import 'package:recomendiaa/core/theme/colors/gradient_colors.dart';
import 'package:recomendiaa/providers/auth-screens/auth_screens_providers.dart';
import 'package:recomendiaa/providers/user_data_providers.dart';
import 'package:recomendiaa/SharedViews/modern_text_field.dart';
import 'package:recomendiaa/SharedViews/buttons/modern_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginView extends ConsumerWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    final loginViewModel = ref.read(loginViewModelProvider.notifier);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: AppGradientColors.primaryGradient,
              backgroundBlendMode: BlendMode.lighten,
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(color: Colors.black.withOpacity(0.75)),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  const Spacer(flex: 1),
                  Text(
                    AppLocalizations.of(context)!.welcomeBack,
                    style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    AppLocalizations.of(context)!
                        .signInToYourAccountAndContinueExploring,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 50),
                  ModernTextField(
                    controller: emailController,
                    hintText: 'Email',
                    icon: Icons.email_outlined,
                  ),
                  const SizedBox(height: 20),
                  ModernTextField(
                    controller: passwordController,
                    hintText: AppLocalizations.of(context)!.password,
                    icon: Icons.lock_outline,
                    isPassword: true,
                  ),
                  const ForgotPassword(),
                  const SizedBox(height: 30),
                  ModernButton(
                    text: AppLocalizations.of(context)!.signIn,
                    onPressed: () async {
                      bool isLogin = await loginViewModel.login(
                          emailController.text, passwordController.text, ref);
                      if (isLogin) {
                        ref.invalidate(authStateProvider);
                        ref.invalidate(userIdProvider);
                        ref.invalidate(userDataProvider);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PageRooter()));
                      }
                    },
                  ),
                  const Spacer(flex: 2),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
