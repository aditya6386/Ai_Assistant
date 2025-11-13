import 'dart:developer';

import 'package:ai_assistant/apis/app_write.dart';
import 'package:ai_assistant/helper/ad_helper.dart';
import 'package:ai_assistant/helper/pref.dart';
import 'package:ai_assistant/screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); //this will turn the application in full screen mode
  
  // Initialize Hive for local storage
  await Pref.initialize();
  
  // Initialize AppWrite to fetch API key (skips fetch if provided locally)
  await AppWrite.init();
  
  // Initialize ads (only for mobile platforms)
  try {
    AdHelper.init();
  } catch (e) {
    // Ads may not work on all platforms, continue without them
    log('Ad initialization failed: $e');
  }
  
  // Set system UI mode and orientation
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: Pref.defaultTheme,
      home: const SplashScreen(),
    );
  }
}
