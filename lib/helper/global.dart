import 'package:flutter/material.dart';

//app name
const appName = 'Ai Assistant';

//media query to store size of device screen
late Size mq;

// API Key is fetched from Appwrite database
// To use a local API key for development, set it via environment variable
// or create a config file (not tracked by git)
// 
// Google Gemini API Key: https://aistudio.google.com/app/apikey
// OpenAI API Key: https://platform.openai.com/api-keys
const String _envGeminiApiKey =
    String.fromEnvironment('GEMINI_API_KEY', defaultValue: '');

String apiKey = _envGeminiApiKey;

void setApiKey(String value) {
  apiKey = value.trim();
}

const String _envGeminiModel =
    String.fromEnvironment('GEMINI_MODEL', defaultValue: 'gemini-2.5-pro');

String geminiModel = _envGeminiModel;

void setGeminiModel(String value) {
  final trimmed = value.trim();
  if (trimmed.isEmpty) return;
  geminiModel = trimmed;
}