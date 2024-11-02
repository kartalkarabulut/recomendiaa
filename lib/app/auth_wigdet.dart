import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recomendiaa/Views/Auth/auth_screen.dart';
import 'package:recomendiaa/Views/Auth/register/register_view.dart';
import 'package:recomendiaa/app/page_rooter_widget.dart';
import 'package:recomendiaa/providers/user_data_providers.dart';

class AuthWidget extends ConsumerWidget {
  const AuthWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    print("auth state: $authState");
    return authState.when(
      data: (user) {
        if (user != null) {
          return PageRooter();
        }
        return const AuthView();
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Hata: $error')),
    );
  }
}
