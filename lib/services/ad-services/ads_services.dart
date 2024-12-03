import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:logger/logger.dart';

class NewAdService {
  static const String _interstitialAdUnitId =
      'ca-app-pub-9468367932651303/2073876483';

  InterstitialAd? _interstitialAd;
  bool _isAdLoaded = false;

  final Logger _logger = Logger();

  void loadInterstitialAd() {
    _logger.i('Geçiş reklamı yükleme işlemi başlatıldı');
    InterstitialAd.load(
      adUnitId: _interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _logger.i('Geçiş reklamı başarıyla yüklendi');
          _interstitialAd = ad;
          _isAdLoaded = true;

          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (InterstitialAd ad) {
              _logger.i('Geçiş reklamı kapatıldı');
              ad.dispose();
              _interstitialAd = null;
              _isAdLoaded = false;

              // Yeni reklam yükleme
              _logger.i('Yeni geçiş reklamı yükleniyor');
              loadInterstitialAd();
            },
            onAdFailedToShowFullScreenContent:
                (InterstitialAd ad, AdError error) {
              _logger.e(
                  'Geçiş reklamı gösterilirken hata oluştu: ${error.message}');
              ad.dispose();
              _interstitialAd = null;
              _isAdLoaded = false;
            },
          );
        },
        onAdFailedToLoad: (LoadAdError error) {
          _logger.e('Reklam yüklenemedi: ${error.message}');
          _isAdLoaded = false;
        },
      ),
    );
  }

  void showInterstitialAd() {
    if (_isAdLoaded && _interstitialAd != null) {
      _logger.i('Geçiş reklamı gösteriliyor');
      _interstitialAd!.show();
    } else {
      _logger.w('Reklam henüz yüklenmedi');
      _logger.i('Reklam yükleme işlemi tekrar başlatılıyor');
      loadInterstitialAd(); // Eğer reklam yüklenmediyse tekrar yüklemeyi dene
    }
  }

  void dispose() {
    _interstitialAd?.dispose();
  }
}
