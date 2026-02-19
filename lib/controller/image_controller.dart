import 'dart:developer';

import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:gal/gal.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../apis/apis.dart';
import '../helper/global.dart';
import '../helper/my_dialog.dart';

// Conditional import for File operations (only on non-web platforms)
import 'dart:io' if (dart.library.html) 'file_stub.dart' as io;

enum Status { none, loading, complete }

class ImageController extends GetxController {
  final textC = TextEditingController();

  final status = Status.none.obs;

  final url = ''.obs;

  final imageList = <String>[].obs;

  Future<void> createAIImage() async {
    if (textC.text.trim().isEmpty) {
      MyDialog.info('Provide some beautiful image description!');
      return;
    }

    // Check if API key is available
    if (apiKey.isEmpty) {
      status.value = Status.none;
      MyDialog.error('API Key not configured. Please check your Appwrite setup or configure the API key.');
      return;
    }

    try {
      OpenAI.apiKey = apiKey;
      status.value = Status.loading;

      OpenAIImageModel image = await OpenAI.instance.image.create(
        prompt: textC.text,
        n: 1,
        size: OpenAIImageSize.size512,
        responseFormat: OpenAIImageResponseFormat.url,
      );
      
      if (image.data.isNotEmpty) {
        url.value = image.data[0].url.toString();
        status.value = Status.complete;
      } else {
        status.value = Status.none;
        MyDialog.error('Failed to generate image. Please try again.');
      }
    } catch (e) {
      status.value = Status.none;
      MyDialog.error('Failed to create image: ${e.toString()}');
      log('createAIImageE: $e');
    }
  }

  void downloadImage() async {
    try {
      // Check if running on web - gallery saver doesn't work on web
      if (kIsWeb) {
        MyDialog.info('Download feature is not available on web. Please use Share instead.');
        return;
      }

      //To show loading
      MyDialog.showLoadingDialog();

      log('url: ${url.value}');

      final bytes = (await get(Uri.parse(url.value))).bodyBytes;
      final dir = await getTemporaryDirectory();
      final filePath = '${dir.path}/ai_image.png';
      
      // Write bytes to file
      final file = io.File(filePath);
      await file.writeAsBytes(bytes);

      log('filePath: $filePath');
      //save image to gallery (mobile only)
      try {
        await Gal.putImage(filePath, album: appName);
        //hide loading
        Get.back();
        MyDialog.success('Image Downloaded to Gallery!');
      } catch (e) {
        //hide loading
        Get.back();
        MyDialog.error('Failed to save image: $e');
        log('gallerySaverE: $e');
      }
    } catch (e) {
      //hide loading
      if (Get.isDialogOpen == true) Get.back();
      MyDialog.error('Something Went Wrong (Try again in sometime)!');
      log('downloadImageE: $e');
    }
  }

  void shareImage() async {
    try {
      //To show loading
      MyDialog.showLoadingDialog();

      log('url: ${url.value}');

      if (kIsWeb) {
        // For web, share the URL directly
        Get.back();
        await Share.share(
          'Check out this Amazing Image created by Ai Assistant App by Harsh H. Rajpurohit\n${url.value}',
        );
      } else {
        // For mobile/desktop, download bytes and share
        final bytes = (await get(Uri.parse(url.value))).bodyBytes;
        final dir = await getTemporaryDirectory();
        final filePath = '${dir.path}/ai_image.png';
        
        // Write bytes to file
        final file = io.File(filePath);
        await file.writeAsBytes(bytes);

        log('filePath: $filePath');

        //hide loading
        Get.back();

        await Share.shareXFiles([XFile(filePath)],
            text:
                'Check out this Amazing Image created by Ai Assistant App by Harsh H. Rajpurohit');
      }
    } catch (e) {
      //hide loading
      if (Get.isDialogOpen == true) Get.back();
      MyDialog.error('Something Went Wrong (Try again in sometime)!');
      log('shareImageE: $e');
    }
  }

  Future<void> searchAiImage() async {
    //if prompt is not empty
    if (textC.text.trim().isNotEmpty) {
      status.value = Status.loading;

      imageList.value = await APIs.searchAiImages(textC.text);

      if (imageList.isEmpty) {
        MyDialog.error('Something went wrong (Try again in sometime)');

        return;
      }

      url.value = imageList.first;

      status.value = Status.complete;
    } else {
      MyDialog.info('Provide some beautiful image description!');
    }
  }
}