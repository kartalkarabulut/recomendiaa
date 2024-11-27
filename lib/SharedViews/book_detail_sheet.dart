import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recomendiaa/SharedViews/shared_snackbars.dart';
import 'package:recomendiaa/core/constants/app_constans.dart';
import 'package:recomendiaa/core/constants/image_paths.dart';
import 'package:recomendiaa/core/shared-funtcions/all_formatters.dart';
import 'package:recomendiaa/core/theme/colors/app_colors.dart';
import 'package:recomendiaa/core/theme/colors/gradient_colors.dart';
import 'package:recomendiaa/core/theme/styles/app_text_styles.dart';
import 'package:recomendiaa/models/book_recomendation_model.dart';
import 'package:recomendiaa/providers/book_providers.dart';
import 'package:recomendiaa/services/recomendation-history/book_recm_data_imp.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BookDetailSheet extends StatelessWidget {
  const BookDetailSheet({
    super.key,
    required this.book,
    required this.isSmartSuggestion,
  });

  final BookRecomendationModel book;
  final bool isSmartSuggestion;

  @override
  Widget build(BuildContext context) {
    double screenHeight = AppConstants.screenHeight(context);
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      child: Stack(
        children: [
          // Arka plan container'ı
          Container(
            height: screenHeight * 0.8,
            decoration: BoxDecoration(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
              gradient: AppGradientColors.primaryGradient,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  spreadRadius: 2,
                )
              ],
            ),
          ),

          // Ana içerik container'ı
          Container(
            height: screenHeight * 0.8,
            color: Colors.black.withOpacity(0.6),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  // Üst çizgi indikatörü
                  Container(
                    height: 4,
                    width: 40,
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),

                  // Kitap başlığı ve temel bilgiler
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.orange.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Image.asset(
                                ImagePaths.bookHeader,
                                width: 24,
                                height: 24,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                book.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.xLargeTextStyle.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.bluishColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                "assets/images/categories.png",
                                color: Colors.orange,
                                width: 20,
                                height: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                book.genre,
                                style: AppTextStyles.largeTextStyle.copyWith(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Yazar ve sayfa bilgileri
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.deepOrange.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.person_outline,
                                color: Colors.deepOrange,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                book.author,
                                style: AppTextStyles.largeTextStyle.copyWith(
                                  color: Colors.deepOrange,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.bluishColor.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.book_outlined,
                                color: AppColors.bluishColor,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              AppLocalizations.of(context)!.pages(book.pages),
                              style: AppTextStyles.largeTextStyle.copyWith(
                                color: AppColors.bluishColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Kitap açıklaması
                  Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      book.description,
                      style: AppTextStyles.largeTextStyle.copyWith(
                        height: 1.5,
                        letterSpacing: 0.5,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ),

                  // Anahtar kelimeler
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            AppLocalizations.of(context)!.relatedTags,
                            style: AppTextStyles.largeTextStyle.copyWith(
                              color: Colors.grey,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: book.keywords
                              .map((keyword) => Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.orange.withOpacity(0.6),
                                          Colors.deepOrange.withOpacity(0.6),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      AllFormatters.capitalizeFirstLetter(
                                          keyword),
                                      style:
                                          AppTextStyles.largeTextStyle.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ))
                              .toList(),
                        ),
                      ],
                    ),
                  ),

                  // Silme butonu
                  if (!isSmartSuggestion)
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Consumer(
                        builder: (context, ref, child) => ElevatedButton(
                          onPressed: () async {
                            await BookRecomendationDataImp()
                                .deleteRecomendation(book.title);
                            ref.invalidate(getBookRecomendationsProvider);
                            SharedSnackbars.showSuccessSnackBar(context,
                                AppLocalizations.of(context)!.bookDeleted);
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.withOpacity(0.8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 4,
                          ),
                          child: Text(
                            AppLocalizations.of(context)!.deleteThisBook,
                            style: AppTextStyles.largeTextStyle.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
