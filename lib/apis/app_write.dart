import 'dart:developer';

import 'package:appwrite/appwrite.dart';

import '../helper/global.dart';

class AppWrite {
  static final _client = Client();
  static final _database = Databases(_client);

  static Future<void> init() async {
    _client
        .setEndpoint('https://cloud.appwrite.io/v1')
        .setProject('658813fd62bd45e744cd')
        .setSelfSigned(status: true);

    if (apiKey.isNotEmpty) {
      log('API key loaded from local configuration. Skipping Appwrite fetch.');
      return;
    }

    await getApiKey();
  }

  static Future<String> getApiKey() async {
    try {
      final d = await _database.getDocument(
          databaseId: 'MyDatabase',
          collectionId: 'ApiKey',
          documentId: 'chatGptKey');

      final fetchedKey = (d.data['apiKey'] as String?)?.trim() ?? '';
      final fetchedModel = (d.data['geminiModel'] as String?)?.trim();
      if (fetchedKey.isNotEmpty) {
        setApiKey(fetchedKey);
        log('API key fetched from Appwrite.');
      } else {
        log('Appwrite returned an empty API key.');
      }
      if (fetchedModel != null && fetchedModel.isNotEmpty) {
        setGeminiModel(fetchedModel);
        log('Gemini model set from Appwrite: $fetchedModel');
      }
      return apiKey;
    } catch (e, st) {
      log('Failed to fetch API key from Appwrite: $e', stackTrace: st);
      return '';
    }
  }
}