import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class NewAdService {
  static final NewAdService _instance = NewAdService._internal();

  // Factory constructor
  factory NewAdService() {
    return _instance;
  }

  // Private constructor
  NewAdService._internal();
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

class AdServices {
  InterstitialAd? interstitialAd;
  BannerAd? bannerAd;
  final Logger _logger = Logger();

  // Test ID'leri
  final String _interstitialAdTestId = 'ca-app-pub-9468367932651303/2073876483';
  final String _bannerAdTestId = 'ca-app-pub-3940256099942544/6300978111';

  // Gerçek ID'ler - Yayınlarken bu değerleri güncelleyin
  final String _interstitialAdRealId = 'ca-app-pub-9468367932651303/2073876483';
  final String _bannerAdRealId = 'ca-app-pub-9468367932651303/2073876483';

  String get _interstitialAdId =>
      kDebugMode ? _interstitialAdTestId : _interstitialAdRealId;
  String get _bannerAdId => kDebugMode ? _bannerAdTestId : _bannerAdRealId;

  // Geçiş reklamını yükle
  Future<void> loadInterstitialAd(void Function() updateState) async {
    if (interstitialAd != null) {
      return;
    }

    try {
      await InterstitialAd.load(
        adUnitId: _interstitialAdId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            _logger.i('Geçiş reklamı başarıyla yüklendi');
            interstitialAd = ad;
            updateState();

            ad.fullScreenContentCallback = FullScreenContentCallback(
              onAdDismissedFullScreenContent: (ad) {
                _logger.i('Geçiş reklamı kapatıldı');
                interstitialAd = null;
                ad.dispose();
                // Reklam kapandığında yeni reklam yükle
                loadInterstitialAd(updateState);
              },
              onAdFailedToShowFullScreenContent: (ad, error) {
                _logger.e('Geçiş reklamı gösterilirken hata: $error');
                interstitialAd = null;
                ad.dispose();
                // Hata durumunda yeni reklam yükle
                loadInterstitialAd(updateState);
              },
            );

            updateState();
          },
          onAdFailedToLoad: (LoadAdError error) {
            _logger.e('Geçiş reklamı yüklenemedi: $error');
            interstitialAd = null;
          },
        ),
      );
    } catch (e) {
      _logger.e('Geçiş reklamı yüklenirken beklenmeyen hata: $e');
      interstitialAd = null;
    }
  }

  Future<void> showInterstitialAd(void Function() updateState) async {
    if (interstitialAd == null) {
      _logger.w('Geçiş reklamı henüz yüklenmedi, yükleniyor...');
      await loadInterstitialAd(updateState);
      await Future.delayed(const Duration(milliseconds: 500));
    }

    if (interstitialAd != null) {
      try {
        await interstitialAd!.show();
      } catch (e) {
        _logger.e('Reklam gösteriminde hata: $e');
        // Hata durumunda yeni reklam yükle
        loadInterstitialAd(updateState);
      }
    } else {
      _logger.w('Reklam hala yüklenemedi');
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

class AddServices2 {
  static const bannerAddUnitId = "ca-app-pub-9468367932651303~2271711286";
  static const interstitialAddUnitId =
      'ca-app-pub-9468367932651303/2073876483'; //test ad id
  //  real id "ca-app-pub-9468367932651303/1741789325";
  static const int maxFailedLoadAttempts = 3;
  static const nativeAddUnitId = "ca-app-pub-9468367932651303~2271711286";

  BannerAd? bannerAd;
  InterstitialAd? interstitialAd;
  NativeAd? nativeAd;

  int _numInterstitialLoadAttempts = 0;

  void loadBannerAd({required void Function(Ad) onAdLoaded}) {
    bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: bannerAddUnitId,
      listener: BannerAdListener(
        onAdLoaded: onAdLoaded,
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          debugPrint("Banner reklam yüklenemedi");
        },
      ),
      request: const AdRequest(),
    )..load();
  }

  void createInterstitialAd({
    required void Function() onAdLoaded,
    required void Function(String) onAdFailedToLoad,
  }) {
    InterstitialAd.load(
      adUnitId: interstitialAddUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          interstitialAd = ad;
          _numInterstitialLoadAttempts = 0;
          onAdLoaded();
        },
        onAdFailedToLoad: (LoadAdError error) {
          _numInterstitialLoadAttempts += 1;
          interstitialAd = null;
          if (_numInterstitialLoadAttempts <= maxFailedLoadAttempts) {
            createInterstitialAd(
              onAdLoaded: onAdLoaded,
              onAdFailedToLoad: onAdFailedToLoad,
            );
          } else {
            onAdFailedToLoad(error.message);
          }
        },
      ),
    );
  }

  void showInterstitialAd({
    required void Function() onAdDismissed,
    required void Function(String) onAdFailedToShow,
  }) {
    if (interstitialAd == null) {
      debugPrint("Gösterilecek hazır inter reklam yok");
      return;
    }

    interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (InterstitialAd ad) {
      ad.dispose();
      onAdDismissed();
    }, onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
      ad.dispose();
      onAdFailedToShow(error.message);
    });
    interstitialAd!.show();
    interstitialAd = null;
  }

  void loadNativeAd({required void Function(Ad) onAdLoaded}) {
    nativeAd = NativeAd(
      adUnitId: nativeAddUnitId,
      factoryId: 'listTile',
      request: const AdRequest(),
      listener: NativeAdListener(
        onAdLoaded: onAdLoaded,
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          debugPrint('Native reklam yüklenemedi: $error');
        },
      ),
    )..load();
  }

  void disposeAds() {
    bannerAd?.dispose();
    interstitialAd?.dispose();
    nativeAd?.dispose();
  }
}
