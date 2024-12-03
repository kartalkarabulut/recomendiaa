// import 'dart:ui';

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:recomendiaa/core/constants/category_names.dart';
// import 'package:recomendiaa/core/shared-funtcions/all_formatters.dart';
// import 'package:recomendiaa/core/theme/colors/gradient_colors.dart';
// import 'package:recomendiaa/core/theme/styles/app_text_styles.dart';
// import 'package:recomendiaa/providers/user_data_providers.dart';
// import 'package:recomendiaa/services/recomendation-history/recomendation_database.dart';
// import 'package:recomendiaa/services/user/data/to-firestore/user_data_to_firestore_imp.dart';

// class ProfileViewModel extends StateNotifier<ProfileViewState> {
//   ProfileViewModel() : super(ProfileViewState());

//   void toggleMovieCategoriesEditing() {
//     state = state.copyWith(
//       isMovieCategoriesEditing: !state.isMovieCategoriesEditing,
//     );
//   }

//   void toggleBookCategoriesEditing() {
//     state = state.copyWith(
//       isBookCategoriesEditing: !state.isBookCategoriesEditing,
//     );
//   }
// }

// class ProfileViewState {
//   ProfileViewState({
//     this.isLoading = false,
//     this.isMovieCategoriesEditing = false,
//     this.isBookCategoriesEditing = false,
//   });

//   final bool isBookCategoriesEditing;
//   final bool isLoading;
//   final bool isMovieCategoriesEditing;

//   ProfileViewState copyWith({
//     bool? isLoading,
//     bool? isMovieCategoriesEditing,
//     bool? isBookCategoriesEditing,
//   }) {
//     return ProfileViewState(
//       isLoading: isLoading ?? this.isLoading,
//       isMovieCategoriesEditing:
//           isMovieCategoriesEditing ?? this.isMovieCategoriesEditing,
//       isBookCategoriesEditing:
//           isBookCategoriesEditing ?? this.isBookCategoriesEditing,
//     );
//   }
// }

// final profileViewModelProvider =
//     StateNotifierProvider<ProfileViewModel, ProfileViewState>((ref) {
//   return ProfileViewModel();
// });

// class ProfileView extends ConsumerWidget {
//   const ProfileView({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final userData = ref.watch(userDataProvider);
//     final state = ref.watch(profileViewModelProvider);
//     return Scaffold(
//       body: Stack(
//         children: [
//           Container(
//             decoration: BoxDecoration(
//                 gradient: AppGradientColors.primaryGradient,
//                 backgroundBlendMode: BlendMode.lighten),
//           ),
//           Positioned.fill(
//             child: BackdropFilter(
//               filter: ImageFilter.blur(sigmaX: 10, sigmaY: 0),
//               child: Container(color: Colors.black.withOpacity(0.75)),
//             ),
//           ),
//           SingleChildScrollView(
//             child: Column(
//               children: [
//                 SizedBox(
//                   height: 80,
//                   child: Center(
//                     child: Text(
//                       "Profile",
//                       style: AppTextStyles.orbitronlargeTextStyle.copyWith(
//                         fontSize: 24,
//                         // fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),
//                 // CategoryToSelect(categoryName: "Bennn", categoryType: "book"),
//                 // CategoryToSelect(categoryName: "memae", categoryType: "movie"),
//                 userData.when(
//                   data: (user) {
//                     if (user == null) return const SizedBox();
//                     return Padding(
//                       padding: const EdgeInsets.all(20.0),
//                       child: Column(
//                         children: [
//                           Text(
//                             AllFormatters.capitalizeFirstLetter(user.fullName),
//                             style: AppTextStyles.xLargeTextStyle.copyWith(
//                               color: Colors.white,
//                               fontSize: 24,
//                             ),
//                           ),
//                           const SizedBox(height: 10),
//                           Text(
//                             user.email,
//                             style: AppTextStyles.mediumTextStyle.copyWith(
//                               color: Colors.white70,
//                               fontSize: 16,
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                   loading: () =>
//                       const Center(child: CircularProgressIndicator()),
//                   error: (error, stack) => Center(
//                     child: Text(
//                       'Bir hata oluştu: $error',
//                       style: const TextStyle(color: Colors.white),
//                     ),
//                   ),
//                 ),
//                 userData.when(
//                   data: (user) {
//                     if (user == null) return const SizedBox();
//                     return Column(
//                       children: [
//                         const SizedBox(height: 20),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 20),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             children: [
//                               Text(
//                                 "Loved Movie Categories",
//                                 style: AppTextStyles.largeTextStyle.copyWith(
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.bold),
//                               ),
//                             ],
//                           ),
//                         ),
//                         const SizedBox(height: 20),
//                         state.isMovieCategoriesEditing == true
//                             ? const SizedBox.shrink()
//                             : Wrap(spacing: 8, runSpacing: 8, children: [
//                                 for (var a in user.lovedMovieCategories)
//                                   CategoryToSelect(
//                                       categoryName: a, categoryType: "movie"),
//                                 ...user.lovedMovieCategories.map((category) {
//                                   return CategoryToSelect(
//                                       categoryName: category,
//                                       categoryType: "movie");
//                                 }).toList(),
//                                 GestureDetector(
//                                   onTap: () {
//                                     ref
//                                         .read(profileViewModelProvider.notifier)
//                                         .toggleMovieCategoriesEditing();
//                                   },
//                                   child: Container(
//                                     padding: const EdgeInsets.symmetric(
//                                         horizontal: 12, vertical: 6),
//                                     decoration: BoxDecoration(
//                                       // color: Colors.deepOrange.withOpacity(0.2),
//                                       borderRadius: BorderRadius.circular(20),
//                                       // border: Border.all(
//                                       //   color: Colors.deepOrange.withOpacity(0.5),
//                                       // ),
//                                     ),
//                                     child: Text(
//                                       "Edit",
//                                       style: AppTextStyles.mediumTextStyle
//                                           .copyWith(
//                                         // color: Colors.white70,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ),
//                                 )
//                               ]),
//                         const SizedBox(
//                           height: 20,
//                         ),
//                         state.isMovieCategoriesEditing == false
//                             ? const SizedBox.shrink()
//                             : Padding(
//                                 padding:
//                                     const EdgeInsets.symmetric(horizontal: 10),
//                                 child: Wrap(
//                                   spacing: 10,
//                                   runSpacing: 10,
//                                   children: [
//                                     ...CategoryNames.categories.map((category) {
//                                       return CategoryToSelect(
//                                           categoryName: category,
//                                           categoryType: "movie");
//                                     }).toList(),
//                                     GestureDetector(
//                                       onTap: () async {
//                                         final movieCategoriesToSave =
//                                             ref.watch(moviesToSaveProvider);
//                                         await UserDataToFirestoreImp()
//                                             .updateLovedCategories(
//                                                 movieCategoriesToSave,
//                                                 RecomendationType.movie);
//                                         ref.invalidate(userDataProvider);
//                                         ref
//                                             .read(profileViewModelProvider
//                                                 .notifier)
//                                             .toggleMovieCategoriesEditing();
//                                       },
//                                       child: Container(
//                                         padding: const EdgeInsets.symmetric(
//                                             horizontal: 12, vertical: 6),
//                                         decoration: BoxDecoration(
//                                           // color: Colors.deepOrange.withOpacity(0.2),
//                                           borderRadius:
//                                               BorderRadius.circular(20),
//                                           // border: Border.all(
//                                           //   color: Colors.deepOrange.withOpacity(0.5),
//                                           // ),
//                                         ),
//                                         child: Text(
//                                           "Save",
//                                           style: AppTextStyles.mediumTextStyle
//                                               .copyWith(
//                                             // color: Colors.white70,
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                       ),
//                                     )
//                                   ],
//                                 ),
//                               ),
//                         const SizedBox(height: 30),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 20),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             children: [
//                               Text(
//                                 "Loved Book Categories",
//                                 style: AppTextStyles.largeTextStyle.copyWith(
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.bold),
//                               ),
//                             ],
//                           ),
//                         ),
//                         const SizedBox(height: 20),
//                         state.isBookCategoriesEditing == true
//                             ? const SizedBox.shrink()
//                             : Wrap(spacing: 8, runSpacing: 8, children: [
//                                 ...user.lovedBookCategories.map((category) {
//                                   return CategoryToSelect(
//                                       categoryName: category,
//                                       categoryType: "book");
//                                 }).toList(),
//                                 GestureDetector(
//                                   onTap: () {
//                                     ref
//                                         .read(profileViewModelProvider.notifier)
//                                         .toggleBookCategoriesEditing();
//                                   },
//                                   child: Container(
//                                     padding: const EdgeInsets.symmetric(
//                                         horizontal: 12, vertical: 6),
//                                     decoration: BoxDecoration(
//                                       // color: Colors.deepOrange.withOpacity(0.2),
//                                       borderRadius: BorderRadius.circular(20),
//                                       // border: Border.all(
//                                       //   color: Colors.deepOrange.withOpacity(0.5),
//                                       // ),
//                                     ),
//                                     child: Text(
//                                       "Edit",
//                                       style: AppTextStyles.mediumTextStyle
//                                           .copyWith(
//                                         // color: Colors.white70,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ),
//                                 )
//                               ]),
//                         const SizedBox(
//                           height: 20,
//                         ),
//                         state.isBookCategoriesEditing == false
//                             ? const SizedBox.shrink()
//                             : Padding(
//                                 padding:
//                                     const EdgeInsets.symmetric(horizontal: 10),
//                                 child: Wrap(
//                                   spacing: 10,
//                                   runSpacing: 10,
//                                   children: [
//                                     ...CategoryNames.bookCategories
//                                         .map((category) {
//                                       return CategoryToSelect(
//                                           categoryName: category,
//                                           categoryType: "book");
//                                     }).toList(),
//                                     GestureDetector(
//                                       onTap: () async {
//                                         List<String> bookCategoriesToSave =
//                                             ref.watch(booksToSaveProvider);
//                                         await UserDataToFirestoreImp()
//                                             .updateLovedCategories(
//                                                 bookCategoriesToSave,
//                                                 RecomendationType.book);
//                                         ref.invalidate(userDataProvider);
//                                         ref
//                                             .read(profileViewModelProvider
//                                                 .notifier)
//                                             .toggleBookCategoriesEditing();
//                                       },
//                                       child: Container(
//                                         padding: const EdgeInsets.symmetric(
//                                             horizontal: 12, vertical: 6),
//                                         decoration: BoxDecoration(
//                                           // color: Colors.deepOrange.withOpacity(0.2),
//                                           borderRadius:
//                                               BorderRadius.circular(20),
//                                           // border: Border.all(
//                                           //   color: Colors.deepOrange.withOpacity(0.5),
//                                           // ),
//                                         ),
//                                         child: Text(
//                                           "Save",
//                                           style: AppTextStyles.mediumTextStyle
//                                               .copyWith(
//                                             // color: Colors.white70,
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                       ),
//                                     )
//                                   ],
//                                 ),
//                               ),
//                       ],
//                     );
//                   },
//                   loading: () => const SizedBox(),
//                   error: (_, __) => const SizedBox(),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class CategoryToSelect extends ConsumerStatefulWidget {
//   CategoryToSelect(
//       {super.key, required this.categoryName, required this.categoryType});

//   String categoryName;
//   String categoryType;

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() =>
//       CategoryToSelectState();
// }

// class CategoryToSelectState extends ConsumerState<CategoryToSelect> {
//   bool isSelected = false;

//   @override
//   Widget build(BuildContext context) {
//     final moviesToSave = ref.read(moviesToSaveProvider);
//     final booksToSave = ref.read(booksToSaveProvider);
//     Color bookColor = isSelected
//         ? Colors.deepOrange.withOpacity(0.5)
//         : Colors.deepOrange.withOpacity(0.2);
//     Color movieColor = isSelected
//         ? Colors.deepPurple.withOpacity(0.5)
//         : Colors.deepPurple.withOpacity(0.2);
//     return GestureDetector(
//       onTap: () {
//         if (isSelected == false) {
//           setState(() {
//             isSelected = true;
//           });
//           if (widget.categoryType == "book") {
//             booksToSave.add(widget.categoryName);
//           } else {
//             moviesToSave.add(widget.categoryName);
//           }
//         } else {
//           if (widget.categoryType == "book") {
//             booksToSave.remove(widget.categoryName);
//           } else {
//             moviesToSave.remove(widget.categoryName);
//           }
//           setState(() {
//             isSelected = false;
//           });
//         }
//         print(moviesToSave.length);
//         print(booksToSave.length);
//       },
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//         decoration: BoxDecoration(
//           color: widget.categoryType == "book" ? bookColor : movieColor,
//           borderRadius: BorderRadius.circular(20),
//           border: Border.all(
//             color: widget.categoryType == "book"
//                 ? Colors.deepOrange.withOpacity(0.5)
//                 : Colors.deepPurple.withOpacity(0.5),
//           ),
//         ),
//         child: Text(
//           AllFormatters.capitalizeFirstLetter(widget.categoryName),
//           style: AppTextStyles.mediumTextStyle.copyWith(
//             color: isSelected ? Colors.white : Colors.white70,
//             fontSize: 14,
//             fontWeight: isSelected ? FontWeight.bold : null,
//           ),
//         ),
//       ),
//     );
//   }
// }

// final moviesToSaveProvider = StateProvider<List<String>>((ref) {
//   return [];
// });

// final booksToSaveProvider = StateProvider<List<String>>((ref) {
//   return [];
// });
