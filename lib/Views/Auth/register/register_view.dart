import "dart:ui";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:recomendiaa/Views/Auth/register/category-selection/loved_categories.dart";
import "package:recomendiaa/core/theme/colors/app_colors.dart";
import "package:recomendiaa/core/theme/colors/gradient_colors.dart";
import "package:recomendiaa/core/theme/styles/app_text_styles.dart";
import "package:recomendiaa/models/user_model.dart";
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final registeringUserProvider = StateProvider<UserModel>((ref) {
  return UserModel(
    id: '', // Firebase'den gelecek
    fullName: '',
    email: '',
    password: '',
    bookPromptHistory: [],
    moviePromptHistory: [],
    savedMovies: [],
    savedBooks: [],
    lastSuggestedMoviePrompts: [],
    lastSuggestedMovies: [],
    lastSuggestedBookPrompts: [],
    lastSuggestedBooks: [],
    lovedMovieCategories: [],
    lovedBookCategories: [],
  );
});

class RegisterViewState {
  RegisterViewState({this.currentFieldIndex = 0, UserModel? userModel})
      : userModel = userModel ??
            UserModel(
              id: '', // Firebase'den gelecek
              fullName: '',
              email: '',
              password: '',
              bookPromptHistory: [],
              moviePromptHistory: [],
              savedMovies: [],
              savedBooks: [],
              lastSuggestedMoviePrompts: [],
              lastSuggestedMovies: [],
              lastSuggestedBookPrompts: [],
              lastSuggestedBooks: [],
              lovedMovieCategories: [],
              lovedBookCategories: [],
            ); // 2 yerine 0'dan başlayalım

  final int currentFieldIndex;
  final UserModel userModel;

  RegisterViewState copyWith({int? currentFieldIndex, UserModel? userModel}) {
    return RegisterViewState(
      userModel: userModel ?? this.userModel,
      currentFieldIndex: currentFieldIndex ?? this.currentFieldIndex,
    );
  }
}

class RegisterViewNotifier extends StateNotifier<RegisterViewState> {
  RegisterViewNotifier() : super(RegisterViewState());

  void updateUserField(String value) {
    switch (state.currentFieldIndex) {
      case 0:
        state = state.copyWith(
          userModel: state.userModel.copyWith(fullName: value),
        );
        break;
      case 1:
        state = state.copyWith(
          userModel: state.userModel.copyWith(email: value),
        );
        break;
      case 2:
        state = state.copyWith(
          userModel: state.userModel.copyWith(password: value),
        );
        break;
    }
  }

  void nextField() {
    if (state.currentFieldIndex < 2) {
      // Maksimum indeksi kontrol edelim
      state = state.copyWith(currentFieldIndex: state.currentFieldIndex + 1);
    }
  }

  void backField() {
    if (state.currentFieldIndex > 0) {
      state = state.copyWith(currentFieldIndex: state.currentFieldIndex - 1);
    }
  }
}

final registerViewNotifierProvider =
    StateNotifierProvider<RegisterViewNotifier, RegisterViewState>((ref) {
  return RegisterViewNotifier();
});

class RegisterView extends ConsumerStatefulWidget {
  const RegisterView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RegisterViewState();
}

class _RegisterViewState extends ConsumerState<RegisterView> {
  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  final TextEditingController emailController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String _getStepTitle(int index) {
    switch (index) {
      case 0:
        return "Önce seni tanıyalım";
      case 1:
        return "E-posta adresini gir";
      case 2:
        return "Güvenli bir şifre belirle";
      default:
        return "";
    }
  }

  String _getStepSubtitle(int index) {
    switch (index) {
      case 0:
        return AppLocalizations.of(context)!.whatsYourName;
      case 1:
        return AppLocalizations.of(context)!.toContactYou;
      case 2:
        return AppLocalizations.of(context)!.toKeepAcSecure;
      default:
        return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(registerViewNotifierProvider);
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                gradient: AppGradientColors.primaryGradient,
                backgroundBlendMode: BlendMode.lighten),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 0),
              child: Container(color: Colors.black.withOpacity(0.75)),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: screenHeight * 0.1),
                    LinearProgressIndicator(
                      value: (state.currentFieldIndex + 1) / 3,
                      backgroundColor: Colors.white.withOpacity(0.3),
                      valueColor:
                          AlwaysStoppedAnimation<Color>(AppColors.primary100),
                    ),
                    SizedBox(height: screenHeight * 0.05),
                    Text(
                      _getStepTitle(state.currentFieldIndex),
                      style: AppTextStyles.largeTextStyle.copyWith(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _getStepSubtitle(state.currentFieldIndex),
                      style: AppTextStyles.mediumTextStyle.copyWith(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.05),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder:
                          (Widget child, Animation<double> animation) {
                        return FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0.1, 0.0),
                              end: Offset.zero,
                            ).animate(animation),
                            child: child,
                          ),
                        );
                      },
                      child: RegisterViewField(
                        key: ValueKey<int>(state.currentFieldIndex),
                        fullNameController: state.currentFieldIndex == 0
                            ? fullNameController
                            : state.currentFieldIndex == 1
                                ? emailController
                                : passwordController,
                        hintText: state.currentFieldIndex == 0
                            ? AppLocalizations.of(context)!.yourName
                            : state.currentFieldIndex == 1
                                ? AppLocalizations.of(context)!
                                    .enterYourEmailAddress
                                : AppLocalizations.of(context)!.password,
                        isPassword: state.currentFieldIndex == 2,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Yeni eklenen navigasyon butonları
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Geri butonu
                        if (state.currentFieldIndex > 0)
                          TextButton.icon(
                            onPressed: () {
                              ref
                                  .read(registerViewNotifierProvider.notifier)
                                  .backField();

                              // Önceki sayfanın controller'ını güncelle
                              final currentIndex = ref
                                  .read(registerViewNotifierProvider)
                                  .currentFieldIndex;
                              final userModel =
                                  ref.read(registeringUserProvider);

                              switch (currentIndex) {
                                case 0:
                                  fullNameController.text = userModel.fullName;
                                  break;
                                case 1:
                                  emailController.text = userModel.email;
                                  break;
                                case 2:
                                  passwordController.text = userModel.password;
                                  break;
                              }
                            },
                            icon: const Icon(Icons.arrow_back,
                                color: Colors.white70),
                            label: Text(
                              AppLocalizations.of(context)!.back,
                              style: AppTextStyles.mediumTextStyle.copyWith(
                                color: Colors.white70,
                              ),
                            ),
                          ),
                        // İleri butonu
                        TextButton.icon(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              if (state.currentFieldIndex == 2) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const LovedCategories(),
                                  ),
                                );
                              } else {
                                ref
                                    .read(registerViewNotifierProvider.notifier)
                                    .nextField();
                              }
                            }
                          },
                          label: Text(
                            state.currentFieldIndex == 2
                                ? AppLocalizations.of(context)!.toCategories
                                : AppLocalizations.of(context)!.continueButton,
                            style: AppTextStyles.mediumTextStyle.copyWith(
                              color: Colors.white,
                            ),
                          ),
                          icon: const Icon(Icons.arrow_forward,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RegisterViewField extends ConsumerWidget {
  const RegisterViewField({
    super.key,
    required this.fullNameController,
    required this.hintText,
    this.isPassword = false,
  });

  final TextEditingController fullNameController;
  final String hintText;
  final bool isPassword;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: double.infinity,
      child: TextFormField(
        controller: fullNameController,
        cursorColor: Colors.white,
        autofocus: true,
        obscureText: isPassword,
        style: const TextStyle(color: Colors.white, fontSize: 20),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return AppLocalizations.of(context)!.cantBeEmpty;
          }
          return null;
        },
        onChanged: (value) {
          Form.of(context).validate();
          final currentIndex =
              ref.read(registerViewNotifierProvider).currentFieldIndex;
          final registeringUser = ref.read(registeringUserProvider.notifier);

          switch (currentIndex) {
            case 0:
              registeringUser
                  .update((state) => state.copyWith(fullName: value));
            case 1:
              registeringUser.update((state) => state.copyWith(email: value));
            case 2:
              registeringUser
                  .update((state) => state.copyWith(password: value));
          }
        },
        decoration: InputDecoration(
          filled: false,
          hintText: hintText,
          contentPadding: const EdgeInsets.all(16),
          hintStyle:
              TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 20),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white.withOpacity(0.5),
              width: 1.5,
            ),
          ),
          errorBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.redAccent,
              width: 1.5,
            ),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}
