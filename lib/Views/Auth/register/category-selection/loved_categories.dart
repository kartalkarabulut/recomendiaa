import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recomendiaa/SharedViews/shared_snackbars.dart';
import 'package:recomendiaa/Views/Auth/register/register_view.dart';
import 'package:recomendiaa/Views/Home/home_page.dart';
import 'package:recomendiaa/app/page_rooter_widget.dart';
// import 'package:recomendiaa/Views/Auth/register/register_view.dart';
import 'package:recomendiaa/core/constants/category_names.dart';
import 'package:recomendiaa/core/theme/colors/app_colors.dart';
import 'package:recomendiaa/core/theme/colors/gradient_colors.dart';
import 'package:recomendiaa/core/theme/styles/app_text_styles.dart';
import 'package:recomendiaa/models/book_recomendation_model.dart';
import 'package:recomendiaa/providers/auth-screens/auth_screens_providers.dart';
import 'package:recomendiaa/providers/user_data_providers.dart';
import 'package:recomendiaa/repository/auth_repository.dart';
import 'package:recomendiaa/repository/recomendation_repository.dart';
import 'package:recomendiaa/services/recomendation-history/recomendation_database.dart';
// import 'package:recomendiaa/providers/auth-screens/auth_screens_providers.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LovedCategories extends ConsumerWidget {
  const LovedCategories({super.key});

  void _showErrorSnackbar(BuildContext context, String message) {
    SharedSnackbars.showErrorSnackBar(context, message);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(lovedCategoriesViewModelProvider);

    return SafeArea(
      child: Scaffold(
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
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 0),
                child: Container(color: Colors.black.withOpacity(0.75)),
              ),
            ),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "AEİAİA",
                      style: AppTextStyles.xLargeTextStyle.copyWith(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "aeiaia",
                      style: AppTextStyles.mediumTextStyle.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 30),
                    _buildCategoryHeader(
                      context,
                      AppLocalizations.of(context)!.movieCategories,
                      "assets/images/categories.png",
                      Colors.orange,
                    ),
                    const SizedBox(height: 15),
                    Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Wrap(
                        spacing: 12,
                        runSpacing: 15,
                        children: CategoryNames.getCategories(context)
                            .map((category) => CategoryNameBox(
                                  title: category,
                                  isMovie: true,
                                  recomendationType: RecomendationType.movie,
                                ))
                            .toList(),
                      ),
                    ),
                    const SizedBox(height: 30),
                    _buildCategoryHeader(
                      context,
                      AppLocalizations.of(context)!.bookCategories,
                      "assets/images/categories.png",
                      Colors.teal,
                    ),
                    const SizedBox(height: 15),
                    Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Wrap(
                        spacing: 12,
                        runSpacing: 15,
                        children: CategoryNames.getBookCategories(context)
                            .map((category) => CategoryNameBox(
                                  title: category,
                                  isMovie: false,
                                  recomendationType: RecomendationType.book,
                                ))
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (state.isLoading == true)
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                  ),
                  child: Center(
                    child: Container(
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2C3E50),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 10,
                            spreadRadius: 5,
                          )
                        ],
                      ),
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 20),
                          decoration: BoxDecoration(
                            color: Color(0xFF2C3E50),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.orange),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                state.registrationStatus,
                                style: AppTextStyles.mediumTextStyle
                                    .copyWith(color: Colors.white),
                                textAlign: TextAlign.center,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
        floatingActionButton: AnimatedOpacity(
          duration: Duration(milliseconds: 300),
          opacity: state.isLoading ? 0.5 : 1,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              gradient: LinearGradient(
                colors: state.isLoading
                    ? [Colors.grey, Colors.grey.shade600]
                    : [Colors.orange.shade400, Colors.deepOrange.shade600],
              ),
              boxShadow: [
                BoxShadow(
                  color: state.isLoading
                      ? Colors.transparent
                      : Colors.deepOrange.withOpacity(0.3),
                  blurRadius: 12,
                  offset: Offset(0, 4),
                  spreadRadius: 2,
                ),
              ],
            ),
            child: FloatingActionButton.extended(
              backgroundColor: Colors.transparent,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              onPressed: state.isLoading
                  ? null
                  : () async {
                      final viewModel =
                          ref.read(lovedCategoriesViewModelProvider.notifier);
                      final selectedMovieCategories =
                          viewModel.state.selectedMovieCategories;
                      final selectedBookCategories =
                          viewModel.state.selectedBookCategories;

                      if (selectedMovieCategories.length < 5) {
                        _showErrorSnackbar(
                          context,
                          AppLocalizations.of(context)!.movieCategoriesMinimum,
                        );
                        return;
                      }

                      if (selectedBookCategories.length < 5) {
                        _showErrorSnackbar(
                          context,
                          AppLocalizations.of(context)!.bookCategoriesMinimum,
                        );
                        return;
                      }

                      final language =
                          Localizations.localeOf(context).languageCode;
                      final user = await viewModel.finishRegistration(
                          context, ref, language);
                      if (user != null) {
                        ref.invalidate(userIdProvider);
                        ref.invalidate(userDataProvider);

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PageRooter(),
                          ),
                        );
                      }
                    },
              label: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.finish,
                      style: AppTextStyles.largeTextStyle.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                    if (!state.isLoading) ...[
                      SizedBox(width: 8),
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ] else
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                            strokeWidth: 2,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryHeader(
      BuildContext context, String title, String iconPath, Color iconColor) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: iconColor.withOpacity(0.3), width: 1),
      ),
      child: Row(
        children: [
          Image.asset(
            iconPath,
            width: 24,
            color: iconColor,
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: AppTextStyles.xLargeTextStyle.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryNameBox extends ConsumerWidget {
  const CategoryNameBox({
    super.key,
    required this.title,
    required this.isMovie,
    required this.recomendationType,
  });

  final bool isMovie;
  final RecomendationType recomendationType;
  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(lovedCategoriesViewModelProvider.notifier);
    final state = ref.watch(lovedCategoriesViewModelProvider);
    final registeringUser = ref.read(registeringUserProvider.notifier);

    final isSelected = isMovie
        ? state.selectedMovieCategories.contains(title)
        : state.selectedBookCategories.contains(title);

    final color = recomendationType == RecomendationType.movie
        ? Colors.orange
        : Colors.teal;

    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      child: GestureDetector(
        onTap: () {
          if (isSelected) {
            if (isMovie) {
              viewModel.removeMovieCategory(title);
              registeringUser.state.lovedMovieCategories.remove(title);
            } else {
              viewModel.removeBookCategory(title);
              registeringUser.state.lovedBookCategories.remove(title);
            }
          } else {
            if (isMovie) {
              registeringUser.state.lovedMovieCategories.add(title);
              viewModel.addMovieCategory(title);
            } else {
              viewModel.addBookCategory(title);
              registeringUser.state.lovedBookCategories.add(title);
            }
          }
        },
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? color.withOpacity(0.2) : Colors.black38,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: isSelected ? color : color.withOpacity(0.3),
                  width: 1.5,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: color.withOpacity(0.3),
                          blurRadius: 8,
                          spreadRadius: 1,
                        )
                      ]
                    : null,
              ),
              child: Text(
                title,
                style: AppTextStyles.mediumTextStyle.copyWith(
                  color: isSelected ? color : Colors.white70,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
            if (isSelected)
              Positioned(
                top: -4,
                right: -4,
                child: Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_circle,
                    color: color,
                    size: 18,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
