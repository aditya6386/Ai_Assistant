import 'dart:developer';

import 'package:easy_audience_network/easy_audience_network.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'my_dialog.dart';

class AdHelper {
  static bool _isInitialized = false;

  static void init() {
    // Ads only work on mobile platforms (Android/iOS)
    if (kIsWeb) {
      log('Ads not supported on web platform');
      return;
    }
    
    try {
      EasyAudienceNetwork.init(
        testMode:
            true, // for testing purpose but comment it before making the app live
      );
      _isInitialized = true;
    } catch (e) {
      log('Failed to initialize ads: $e');
      _isInitialized = false;
    }
  }

  static void showInterstitialAd(VoidCallback onComplete) {
    // Ads only work on mobile platforms
    if (kIsWeb || !_isInitialized) {
      onComplete();
      return;
    }

    try {
      //show loading
      MyDialog.showLoadingDialog();

      final interstitialAd = InterstitialAd(InterstitialAd.testPlacementId);

      interstitialAd.listener = InterstitialAdListener(onLoaded: () {
        //hide loading
        if (Get.isDialogOpen == true) Get.back();
        onComplete();

        interstitialAd.show();
      }, onDismissed: () {
        interstitialAd.destroy();
      }, onError: (i, e) {
        //hide loading
        if (Get.isDialogOpen == true) Get.back();
        onComplete();

        log('interstitial error: $e');
      });

      interstitialAd.load();
    } catch (e) {
      log('Error showing interstitial ad: $e');
      onComplete();
    }
  }

  static Widget nativeAd() {
    // Ads only work on mobile platforms
    if (kIsWeb || !_isInitialized) {
      return const SizedBox.shrink();
    }

    try {
      return SafeArea(
        child: NativeAd(
          placementId: NativeAd.testPlacementId,
          adType: NativeAdType.NATIVE_AD,
          keepExpandedWhileLoading: false,
          expandAnimationDuraion: 1000,
          listener: NativeAdListener(
            onError: (code, message) => log('error'),
            onLoaded: () => log('loaded'),
            onClicked: () => log('clicked'),
            onLoggingImpression: () => log('logging impression'),
            onMediaDownloaded: () => log('media downloaded'),
          ),
        ),
      );
    } catch (e) {
      log('Error showing native ad: $e');
      return const SizedBox.shrink();
    }
  }

  static Widget nativeBannerAd() {
    // Ads only work on mobile platforms
    if (kIsWeb || !_isInitialized) {
      return const SizedBox.shrink();
    }

    try {
      return SafeArea(
        child: NativeAd(
          placementId: NativeAd.testPlacementId,
          adType: NativeAdType.NATIVE_BANNER_AD,
          bannerAdSize: NativeBannerAdSize.HEIGHT_100,
          keepExpandedWhileLoading: false,
          height: 100,
          expandAnimationDuraion: 1000,
          listener: NativeAdListener(
            onError: (code, message) => log('error'),
            onLoaded: () => log('loaded'),
            onClicked: () => log('clicked'),
            onLoggingImpression: () => log('logging impression'),
            onMediaDownloaded: () => log('media downloaded'),
          ),
        ),
      );
    } catch (e) {
      log('Error showing banner ad: $e');
      return const SizedBox.shrink();
    }
  }
}