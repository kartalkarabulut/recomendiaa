import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recomendiaa/Views/Auth/widgets/or_text.dart';
import 'package:recomendiaa/Views/HomePage/home_page.dart';
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
    // final loginState = ref.watch(loginViewModelProvider);
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/logos/logo.png',
                  fit: BoxFit.cover,
                  width: 200,
                  height: 200,
                ),
                AuthField(
                  controller: emailController,
                  hintText: 'Email',
                  // icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),
                AuthField(
                  controller: passwordController,
                  hintText: 'Password',
                  isPassword: true,
                  // icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),
                CustomButton(
                  text: "Login",
                  onPressed: () async {
                    bool isLogin = await loginViewModel.login(
                        emailController.text, passwordController.text, ref);
                    if (isLogin) {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomePage()));
                    }
                  },
                ),
                const SizedBox(height: 20),
                // const OrText(),
                // const SizedBox(height: 20),
                // Image.asset(
                //   'assets/logos/google.png',
                //   height: 50,
                //   width: 50,
                // ),
                // GoogleSignIn(
                //   onPressed: () async {},
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class GoogleSignIn extends StatelessWidget {
  const GoogleSignIn({
    super.key,
    required this.onPressed,
  });
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              // Google ile giriş yapma işlemi buraya eklenecek
            },
            child: Container(
              height: 80,
              width: 90,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.grey[350],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Image.asset(
                'assets/logos/google.png',
                height: 24,
                width: 24,
              ),
            ),
          ),
          const SizedBox(width: 20),
          Text(
            "Use Your\n Google Account",
            textAlign: TextAlign.left,
            style: AppTextStyles.smallTextStyleGF
                .copyWith(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ],
      ),
    );
  }
}

final isButtonWorkignProvider = StateProvider<bool>((ref) {
  return false;
});

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

// class AuthField extends StatelessWidget {
//   const AuthField({
//     super.key,
//     required this.hintText,
//     required this.controller,
//     this.isPassword,
//     this.keyboardType,
//   });
//   final String hintText;
//   final TextEditingController controller;
//   final bool? isPassword;
//   final TextInputType? keyboardType;
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10),
//       child: TextFormField(
//         controller: controller,
//         // textAlign: TextAlign.center,
//         obscureText: isPassword ?? false,
//         keyboardType: keyboardType,
//         // maxLines: 2,
//         decoration: InputDecoration(
//             prefixIcon: const Padding(
//               padding: EdgeInsets.all(8.0),
//               child: Icon(
//                 Icons.email,
//                 color: AppColors.accent100,
//                 size: 40,
//               ),
//             ),
//             // filled: false,
//             fillColor: AppColors.accent200,
//             hintText: hintText,
//             hintStyle: const TextStyle(
//                 color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
//             // border: OutlineInputBorder(),
//             contentPadding: const EdgeInsets.all(20)),
//       ),
//     );
//   }
// }
