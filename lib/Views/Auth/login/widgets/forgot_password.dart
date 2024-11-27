import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recomendiaa/SharedViews/shared_snackbars.dart';
import 'package:recomendiaa/core/theme/colors/app_colors.dart';
import 'package:recomendiaa/core/theme/styles/app_text_styles.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () async {
          final emailController = TextEditingController();

          await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              backgroundColor: AppColors.darkBackgorind,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Text(
                'Reset Password',
                style: AppTextStyles.mediumTextStyle.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: emailController,
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: 'Enter your email address',
                    hintStyle: TextStyle(color: Colors.white54),
                    prefixIcon: Icon(Icons.email, color: Colors.white54),
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Cancel',
                    style: AppTextStyles.mediumTextStyle.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final email = emailController.text.trim();

                    if (email.isEmpty) {
                      SharedSnackbars.showErrorSnackBar(
                        context,
                        'Please enter your email address',
                      );
                      return;
                    }

                    if (!email.contains('@') || !email.contains('.')) {
                      SharedSnackbars.showErrorSnackBar(
                        context,
                        'Please enter a valid email address',
                      );
                      return;
                    }

                    try {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => const Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.deepOrange),
                          ),
                        ),
                      );

                      await FirebaseAuth.instance.sendPasswordResetEmail(
                        email: email,
                      );

                      Navigator.pop(context);
                      Navigator.pop(context);

                      SharedSnackbars.showSuccessSnackBar(
                        context,
                        'Password reset link sent to your email. Please check your spam folder.',
                      );
                    } on FirebaseAuthException catch (e) {
                      Navigator.pop(context);

                      String errorMessage = 'An error occurred';

                      switch (e.code) {
                        case 'user-not-found':
                          errorMessage =
                              'No user found with this email address';
                          break;
                        case 'invalid-email':
                          errorMessage = 'Invalid email address';
                          break;
                        case 'too-many-requests':
                          errorMessage =
                              'Too many attempts. Please try again later';
                          break;
                      }

                      SharedSnackbars.showErrorSnackBar(
                        context,
                        errorMessage,
                      );
                    } catch (e) {
                      Navigator.pop(context);

                      SharedSnackbars.showErrorSnackBar(
                        context,
                        'An unexpected error occurred',
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Send',
                    style: AppTextStyles.mediumTextStyle.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        child: Text(
          'Forgot Password?',
          style: GoogleFonts.poppins(
            color: Colors.deepOrange,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
