import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recomendiaa/SharedViews/shared_snackbars.dart';
import 'package:recomendiaa/core/theme/colors/app_colors.dart';
import 'package:recomendiaa/core/theme/styles/app_text_styles.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
                AppLocalizations.of(context)!.resetPassword,
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
                  decoration: InputDecoration(
                    hintText:
                        AppLocalizations.of(context)!.enterYourEmailAddress,
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
                    AppLocalizations.of(context)!.cancel,
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
                        AppLocalizations.of(context)!
                            .pleaseEnterYourEmailAddress,
                      );
                      return;
                    }

                    if (!email.contains('@') || !email.contains('.')) {
                      SharedSnackbars.showErrorSnackBar(
                        context,
                        AppLocalizations.of(context)!
                            .pleaseEnterAValidEmailAddress,
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
                        AppLocalizations.of(context)!
                            .passwordResetLinkSentToYourEmail,
                      );
                    } on FirebaseAuthException catch (e) {
                      Navigator.pop(context);

                      String errorMessage = 'An error occurred';

                      switch (e.code) {
                        case 'user-not-found':
                          errorMessage = AppLocalizations.of(context)!
                              .noUserFoundWithThisEmailAddress;
                          break;
                        case 'invalid-email':
                          errorMessage =
                              AppLocalizations.of(context)!.invalidEmailAddress;
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
                        AppLocalizations.of(context)!.error(e.toString()),
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
                    AppLocalizations.of(context)!.send,
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
          AppLocalizations.of(context)!.forgotPassword,
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
