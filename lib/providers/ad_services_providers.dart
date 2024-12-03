import 'package:recomendiaa/services/ad-services/ads_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final moviePageAdServiceProvider = Provider<AdverstasingService>((ref) {
  final adService = AdverstasingService();
  ref.onDispose(() {
    adService.dispose();
  });
  return adService;
});

final bookPageAdServiceProvider = Provider<AdverstasingService>((ref) {
  final adService = AdverstasingService();
  ref.onDispose(() {
    adService.dispose();
  });
  return adService;
});
