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

String apiKey = '';