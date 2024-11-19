import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:recomendiaa/Views/Auth/auth_screen.dart';
import 'package:recomendiaa/Views/Auth/register/register_view.dart';
import 'package:recomendiaa/Views/Introduction-Screens/introduction_screen.dart';
import 'package:recomendiaa/app/page_rooter_widget.dart';
import 'package:recomendiaa/providers/user_data_providers.dart';

class AuthWidget extends ConsumerWidget {
  const AuthWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final hasSeenOnboarding = ref.watch(hasSeenOnboardingProvider);

    print("auth state: $authState");
    return authState.when(
      data: (user) {
        if (user != null) {
          return PageRooter();
        }
        return hasSeenOnboarding.when(
          data: (hasSeenOnboarding) {
            return hasSeenOnboarding ? const AuthView() : const AuthView();
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text('Hata: $error')),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Hata: $error')),
    );
  }
}

class OnboardingService {
  static const String _boxName = 'onboardingBox';
  static const String _hasSeenOnboardingKey = 'hasSeenOnboarding';

  // Introduction ekranının görüntülenip görüntülenmediğini kaydetme
  static Future<void> setOnboardingStatus(bool status) async {
    await Hive.openBox(_boxName);
    final box = Hive.box(_boxName);
    await box.put(_hasSeenOnboardingKey, status);
  }

  // Introduction ekranının görüntülenip görüntülenmediğini kontrol etme
  static Future<bool> getOnboardingStatus() async {
    await Hive.openBox(_boxName);
    final box = Hive.box(_boxName);
    return box.get(_hasSeenOnboardingKey, defaultValue: false);
  }
}

final hasSeenOnboardingProvider = FutureProvider<bool>((ref) async {
  return await OnboardingService.getOnboardingStatus();
});
