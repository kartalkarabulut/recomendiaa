import 'package:recomendiaa/services/ad-services/new_ads_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final moviePageAdServiceProvider = Provider<NewAdService>((ref) {
  final adService = NewAdService();
  ref.onDispose(() {
    adService.dispose();
  });
  return adService;
});

final bookPageAdServiceProvider = Provider<NewAdService>((ref) {
  final adService = NewAdService();
  ref.onDispose(() {
    adService.dispose();
  });
  return adService;
});
