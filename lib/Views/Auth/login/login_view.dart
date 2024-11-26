import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recomendiaa/Views/Auth/widgets/or_text.dart';
import 'package:recomendiaa/Views/Home/home_page.dart';
import 'package:recomendiaa/app/page_rooter_widget.dart';
import 'package:recomendiaa/core/constants/app_constans.dart';
import 'package:recomendiaa/core/theme/colors/app_colors.dart';
import 'package:recomendiaa/core/theme/colors/gradient_colors.dart';
import 'package:recomendiaa/core/theme/styles/app_text_styles.dart';
import 'package:recomendiaa/providers/auth-screens/auth_screens_providers.dart';

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
                    'Welcome Back!',
                    style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Sign in to your account and continue exploring',
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
                    hintText: 'Password',
                    icon: Icons.lock_outline,
                    isPassword: true,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        'Forgot Password?',
                        style: GoogleFonts.poppins(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  ModernButton(
                    text: "Sign In",
                    onPressed: () async {
                      bool isLogin = await loginViewModel.login(
                          emailController.text, passwordController.text, ref);
                      if (isLogin) {
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

class ModernTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final bool isPassword;

  const ModernTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.icon,
    this.isPassword = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        style: GoogleFonts.poppins(color: Colors.white),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.white70),
          hintText: hintText,
          hintStyle: GoogleFonts.poppins(color: Colors.white70),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(20),
        ),
      ),
    );
  }
}

class ModernButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const ModernButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(
        color: Colors.deepOrange,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class CustomButton extends ConsumerWidget {
  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.width,
  });

  final VoidCallback? onPressed;
  final String text;
  final double? width;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isButtonWorking = ref.watch(isButtonWorkignProvider);
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        height: 60,
        width: width,
        decoration: BoxDecoration(
            color: Colors.deepOrange, borderRadius: BorderRadius.circular(10)),
        child: Center(
            child: isButtonWorking
                ? const CircularProgressIndicator(
                    color: Colors.black,
                  )
                : Text(
                    text,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 25),
                  )),
      ),
    );
  }
}

class AuthField extends StatelessWidget {
  const AuthField({
    super.key,
    required this.hintText,
    required this.controller,
    this.isPassword,
    this.keyboardType,
    this.iconPath,
  });

  final TextEditingController controller;
  final String hintText;
  final bool? isPassword;
  final TextInputType? keyboardType;
  final String? iconPath;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.greenyColor,
              Colors.deepOrange
              // Colors.blue.shade200,
              // Colors.purple.shade200,
            ],
            stops: [0.0, 1.0],
            transform: GradientRotation(3.14 / 4),
            tileMode: TileMode.clamp,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextFormField(
          controller: controller,
          obscureText: isPassword ?? false,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            prefixIcon: iconPath != null
                ? IconButton(
                    onPressed: null,
                    icon: Image.asset(iconPath!, height: 30, width: 30))
                : const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.email,
                      color: Colors.black,
                      size: 40,
                    ),
                  ),
            fillColor: Colors.transparent,
            hintText: hintText,
            hintStyle: const TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.all(20),
          ),
        ),
      ),
    );
  }
}

final isButtonWorkignProvider = StateProvider<bool>((ref) {
  return false;
});
