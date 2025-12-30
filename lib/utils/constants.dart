import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  static const String openTripMapBaseUrl = 'https://api.opentripmap.com/0.1';
  static const String openTripMapLang = 'en';
  
  static String? _cachedOtmKey;
  static String? _cachedWeatherKey;
  static String? _cachedUnsplashKey;
  static String? _cachedUnsplashAccessKey;
  
  static String get openTripMapApiKey {
    if (_cachedOtmKey != null) return _cachedOtmKey!;
    try {
      _cachedOtmKey = dotenv.env['OPENTRIPMAP_API_KEY'] ?? 'YOUR_OPENTRIPMAP_API_KEY';
    } catch (e) {
      _cachedOtmKey = 'YOUR_OPENTRIPMAP_API_KEY';
    }
    return _cachedOtmKey!;
  }

  static const String weatherBaseUrl = 'https://api.openweathermap.org/data/2.5';
  static String get weatherApiKey {
    if (_cachedWeatherKey != null) return _cachedWeatherKey!;
    try {
      _cachedWeatherKey = dotenv.env['WEATHER_API_KEY'] ?? 'YOUR_WEATHER_API_KEY';
    } catch (e) {
      _cachedWeatherKey = 'YOUR_WEATHER_API_KEY';
    }
    return _cachedWeatherKey!;
  }

  static const String unsplashBaseUrl = 'https://api.unsplash.com';
  static String get unsplashApiKey {
    if (_cachedUnsplashKey != null) return _cachedUnsplashKey!;
    try {
      _cachedUnsplashKey = dotenv.env['UNSPLASH_API_KEY'] ?? 'YOUR_UNSPLASH_API_KEY';
    } catch (e) {
      _cachedUnsplashKey = 'YOUR_UNSPLASH_API_KEY';
    }
    return _cachedUnsplashKey!;
  }
  
  static String get unsplashAccessKey {
    if (_cachedUnsplashAccessKey != null) return _cachedUnsplashAccessKey!;
    try {
      _cachedUnsplashAccessKey = dotenv.env['UNSPLASH_ACCESS_KEY'] ?? 'YOUR_UNSPLASH_ACCESS_KEY';
    } catch (e) {
      _cachedUnsplashAccessKey = 'YOUR_UNSPLASH_ACCESS_KEY';
    }
    return _cachedUnsplashAccessKey!;
  }
  
  static void initializeKeys() {
    try {
      _cachedOtmKey = dotenv.env['OPENTRIPMAP_API_KEY'] ?? 'YOUR_OPENTRIPMAP_API_KEY';
      _cachedWeatherKey = dotenv.env['WEATHER_API_KEY'] ?? 'YOUR_WEATHER_API_KEY';
      _cachedUnsplashKey = dotenv.env['UNSPLASH_API_KEY'] ?? 'YOUR_UNSPLASH_API_KEY';
      _cachedUnsplashAccessKey = dotenv.env['UNSPLASH_ACCESS_KEY'] ?? 'YOUR_UNSPLASH_ACCESS_KEY';
    } catch (e) {
      _cachedOtmKey = 'YOUR_OPENTRIPMAP_API_KEY';
      _cachedWeatherKey = 'YOUR_WEATHER_API_KEY';
      _cachedUnsplashKey = 'YOUR_UNSPLASH_API_KEY';
      _cachedUnsplashAccessKey = 'YOUR_UNSPLASH_ACCESS_KEY';
    }
  }
}

class AppConstants {
  static const String appName = 'Smart Travel Planner';
  static const String storageKeyTrips = 'saved_trips';
  static const String storageKeyUser = 'user_data';
}

