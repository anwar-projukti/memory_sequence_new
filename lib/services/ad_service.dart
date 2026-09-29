import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// ─────────────────────────────────────────────────
/// AD UNIT IDs
/// Replace the values below with your real AdMob IDs
/// before releasing to production.
/// ─────────────────────────────────────────────────
class AdIds {
  // ── Android ──────────────────────────────────────
  static const String _androidBanner =
      'ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX'; // TODO: replace
  static const String _androidInterstitial =
      'ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX'; // TODO: replace
  static const String _androidRewarded =
      'ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX'; // TODO: replace

  // ── iOS ──────────────────────────────────────────
  static const String _iosBanner =
      'ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX'; // TODO: replace
  static const String _iosInterstitial =
      'ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX'; // TODO: replace
  static const String _iosRewarded =
      'ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX'; // TODO: replace

  // ── Test IDs (used automatically in debug mode) ──
  static const String _testBanner =
      'ca-app-pub-3940256099942544/6300978111';
  static const String _testInterstitial =
      'ca-app-pub-3940256099942544/1033173712';
  static const String _testRewarded =
      'ca-app-pub-3940256099942544/5224354917';

  static String get banner => kDebugMode
      ? _testBanner
      : (Platform.isAndroid ? _androidBanner : _iosBanner);

  static String get interstitial => kDebugMode
      ? _testInterstitial
      : (Platform.isAndroid ? _androidInterstitial : _iosInterstitial);

  static String get rewarded => kDebugMode
      ? _testRewarded
      : (Platform.isAndroid ? _androidRewarded : _iosRewarded);
}

/// ─────────────────────────────────────────────────
/// AdService — singleton that manages all ad loading
/// ─────────────────────────────────────────────────
class AdService {
  static final AdService _instance = AdService._internal();
  factory AdService() => _instance;
  AdService._internal();

  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;
  bool _interstitialLoading = false;
  bool _rewardedLoading = false;

  // ── Initialise MobileAds SDK ─────────────────────
  Future<void> initialize() async {
    await MobileAds.instance.initialize();
    _loadInterstitial();
    _loadRewarded();
  }

  // ─────────────────────────────────────────────────
  // BANNER AD
  // ─────────────────────────────────────────────────
  /// Returns a fresh [BannerAd] ready to be loaded by the caller.
  BannerAd buildBannerAd() {
    return BannerAd(
      adUnitId: AdIds.banner,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) => debugPrint('[AdService] Banner loaded'),
        onAdFailedToLoad: (ad, error) {
          debugPrint('[AdService] Banner failed: $error');
          ad.dispose();
        },
      ),
    );
  }

  // ─────────────────────────────────────────────────
  // INTERSTITIAL AD
  // ─────────────────────────────────────────────────
  void _loadInterstitial() {
    if (_interstitialLoading) return;
    _interstitialLoading = true;
    InterstitialAd.load(
      adUnitId: AdIds.interstitial,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          debugPrint('[AdService] Interstitial loaded');
          _interstitialAd = ad;
          _interstitialLoading = false;
          ad.setImmersiveMode(true);
        },
        onAdFailedToLoad: (error) {
          debugPrint('[AdService] Interstitial failed: $error');
          _interstitialAd = null;
          _interstitialLoading = false;
        },
      ),
    );
  }

  /// Shows interstitial if ready, then preloads next one.
  /// [onAdDismissed] is called after the ad closes (or immediately if not loaded).
  void showInterstitial({VoidCallback? onAdDismissed}) {
    if (_interstitialAd == null) {
      debugPrint('[AdService] Interstitial not ready, skipping');
      onAdDismissed?.call();
      _loadInterstitial();
      return;
    }

    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _interstitialAd = null;
        _loadInterstitial();
        onAdDismissed?.call();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        debugPrint('[AdService] Interstitial show failed: $error');
        ad.dispose();
        _interstitialAd = null;
        _loadInterstitial();
        onAdDismissed?.call();
      },
    );

    _interstitialAd!.show();
  }

  bool get isInterstitialReady => _interstitialAd != null;

  // ─────────────────────────────────────────────────
  // REWARDED AD
  // ─────────────────────────────────────────────────
  void _loadRewarded() {
    if (_rewardedLoading) return;
    _rewardedLoading = true;
    RewardedAd.load(
      adUnitId: AdIds.rewarded,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          debugPrint('[AdService] Rewarded loaded');
          _rewardedAd = ad;
          _rewardedLoading = false;
        },
        onAdFailedToLoad: (error) {
          debugPrint('[AdService] Rewarded failed: $error');
          _rewardedAd = null;
          _rewardedLoading = false;
        },
      ),
    );
  }

  /// Shows a rewarded ad.
  /// [onRewarded] is called when the user earns the reward.
  /// [onAdDismissed] is called after the ad closes.
  void showRewarded({
    required VoidCallback onRewarded,
    VoidCallback? onAdDismissed,
    VoidCallback? onNotReady,
  }) {
    if (_rewardedAd == null) {
      debugPrint('[AdService] Rewarded ad not ready');
      onNotReady?.call();
      _loadRewarded();
      return;
    }

    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _rewardedAd = null;
        _loadRewarded();
        onAdDismissed?.call();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        debugPrint('[AdService] Rewarded show failed: $error');
        ad.dispose();
        _rewardedAd = null;
        _loadRewarded();
        onAdDismissed?.call();
      },
    );

    _rewardedAd!.show(
      onUserEarnedReward: (_, reward) {
        debugPrint(
            '[AdService] User earned reward: ${reward.amount} ${reward.type}');
        onRewarded();
      },
    );
  }

  bool get isRewardedReady => _rewardedAd != null;

  void dispose() {
    _interstitialAd?.dispose();
    _rewardedAd?.dispose();
  }
}
