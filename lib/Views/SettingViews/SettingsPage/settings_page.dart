import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:recomendiaa/Views/Auth/auth_screen.dart';
import 'package:recomendiaa/Views/Auth/login/login_view.dart';
import 'package:recomendiaa/core/theme/colors/gradient_colors.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Ayarlar'),
      // ),
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
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/logos/logo1.png',
                  fit: BoxFit.cover,
                  width: 200,
                  height: 200,
                ),
                // AuthField(
                //   controller: emailController,
                //   hintText: 'Email',
                //   // icon: Icons.email,
                //   keyboardType: TextInputType.emailAddress,
                // ),
                // const SizedBox(height: 20),
                // AuthField(
                //   controller: passwordController,
                //   hintText: 'Password',
                //   isPassword: true,
                //   // icon: Icons.email,
                //   keyboardType: TextInputType.emailAddress,
                // ),
                const SizedBox(height: 20),
                CustomButton(
                  text: "Login",
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AuthView()));
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
