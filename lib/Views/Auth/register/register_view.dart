import "dart:ui";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:recomendiaa/Views/Auth/register/loved_categories.dart";
import "package:recomendiaa/core/theme/colors/gradient_colors.dart";
import "package:recomendiaa/core/theme/styles/app_text_styles.dart";
import "package:recomendiaa/models/user_model.dart";

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
  final TextEditingController emailController = TextEditingController();
  List<Widget> fields = [];
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    fields = [
      RegisterViewField(
          fullNameController: fullNameController, hintText: "Share your name"),
      RegisterViewField(
          fullNameController: emailController, hintText: "Share your email"),
      RegisterViewField(
          fullNameController: passwordController, hintText: "Set a password"),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(registerViewNotifierProvider);
    return Scaffold(
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
              child: Container(color: Colors.black.withOpacity(0.5)),
            ),
          ),
          Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              // crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    fields[state.currentFieldIndex],
                  ],
                ),
                // SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: state.currentFieldIndex == 2
          ? FloatingActionButton.extended(
              isExtended: true,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LovedCategories()));
              },
              label: Text(
                "Category Selection",
                style: AppTextStyles.largeTextStyle,
              ),
              icon: const Icon(Icons.arrow_forward),
            )
          : FloatingActionButton.extended(
              isExtended: true,
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // FocusScope.of(context).unfocus();

                  ref.read(registerViewNotifierProvider.notifier).nextField();
                }

                print(state.currentFieldIndex);
                print(state.userModel.toString());
              },
              label: Text(
                "Next",
                style: AppTextStyles.largeTextStyle,
              ),
              icon: const Icon(Icons.arrow_forward),
            ),
    );
  }
}

class RegisterViewField extends ConsumerWidget {
  const RegisterViewField({
    super.key,
    required this.fullNameController,
    required this.hintText,
  });

  final TextEditingController fullNameController;
  final String hintText;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: EdgeInsets.only(right: 40),
      width: 300,
      child: TextFormField(
        controller: fullNameController,
        cursorColor: Colors.black,
        autofocus: true,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Field cannot be empty";
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
          // hintTextDirection: TextDirection.rtl,
          contentPadding: const EdgeInsets.all(10),
          hintStyle: const TextStyle(color: Colors.black, fontSize: 20),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
              width: 1.5,
            ),
          ),
          errorBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.red,
              width: 1.5,
            ),
          ),
          // border: OutlineInputBorder(

          //     borderSide:
          //         BorderSide(color: Colors.black, width: 1.5)),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
              width: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}
