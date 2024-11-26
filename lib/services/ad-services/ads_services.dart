import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

// sdk entegrasyonu için  ca-app-pub-9468367932651303/2073876483
class AdServices {
  InterstitialAd? interstitialAd;
  BannerAd? bannerAd;
  final Logger _logger = Logger();

  // Test ID'leri
  final String _interstitialAdTestId = 'ca-app-pub-9468367932651303~6387964937';
  final String _bannerAdTestId = 'ca-app-pub-3940256099942544/6300978111';

  // Gerçek ID'ler - Yayınlarken bu değerleri güncelleyin
  final String _interstitialAdRealId = 'GERÇEK_INTERSTITIAL_AD_ID';
  final String _bannerAdRealId = 'GERÇEK_BANNER_AD_ID';

  String get _interstitialAdId =>
      kDebugMode ? _interstitialAdTestId : _interstitialAdRealId;
  String get _bannerAdId => kDebugMode ? _bannerAdTestId : _bannerAdRealId;

  // Geçiş reklamını yükle
  Future<void> loadInterstitialAd() async {
    try {
      await InterstitialAd.load(
        adUnitId: _interstitialAdId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            interstitialAd = ad;
            _logger.i('Geçiş reklamı başarıyla yüklendi');

            interstitialAd?.fullScreenContentCallback =
                FullScreenContentCallback(
              onAdDismissedFullScreenContent: (ad) {
                ad.dispose();
                interstitialAd = null;
                _logger.i('Geçiş reklamı kapatıldı');
              },
              onAdFailedToShowFullScreenContent: (ad, error) {
                ad.dispose();
                interstitialAd = null;
                _logger.e('Geçiş reklamı gösterilirken hata: $error');
              },
            );
          },
          onAdFailedToLoad: (LoadAdError error) {
            _logger.e('Geçiş reklamı yüklenemedi: $error');
          },
        ),
      );
    } catch (e) {
      _logger.e('Geçiş reklamı yüklenirken beklenmeyen hata: $e');
    }
  }

  // Geçiş reklamını göster
  Future<void> showInterstitialAd() async {
    if (interstitialAd != null) {
      await interstitialAd?.show();
    } else {
      _logger.w('Geçiş reklamı henüz yüklenmedi');
      await loadInterstitialAd();
    }
  }

  // Banner reklamı oluştur
  BannerAd createBannerAd() {
    return BannerAd(
      adUnitId: _bannerAdId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          bannerAd = ad as BannerAd;
          _logger.i('Banner reklam başarıyla yüklendi');
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          _logger.e('Banner reklam yüklenemedi: $error');
        },
      ),
    );
  }
}
