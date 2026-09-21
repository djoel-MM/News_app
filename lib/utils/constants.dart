import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Constants {
  static const String baseUrl = 'https://newsapi.org/v2';

  // Ambil API key dari environment variables
  static String get apiKey => dotenv.env['API_KEY'] ?? '';

  // Endpoints
  static const String topHeadlines = '/top-headlines';
  static const String everything = '/everything';

  // Kategori: id untuk API, label & ikon untuk UI
  static const List<Map<String, dynamic>> categories = [
    {'id': 'general', 'label': 'Umum', 'icon': Icons.public},
    {'id': 'technology', 'label': 'Teknologi', 'icon': Icons.memory},
    {'id': 'business', 'label': 'Bisnis', 'icon': Icons.trending_up},
    {'id': 'sports', 'label': 'Olahraga', 'icon': Icons.sports_soccer},
    {'id': 'health', 'label': 'Kesehatan', 'icon': Icons.health_and_safety},
    {'id': 'science', 'label': 'Sains', 'icon': Icons.science},
    {'id': 'entertainment', 'label': 'Hiburan', 'icon': Icons.theater_comedy},
  ];

  static String get defaultCategory => categories.first['id'] as String;
  static const String defaultCountry = 'us';
  static const String appName = 'Kabar';
  static const String appTagline = 'Berita untuk semua.';
  static const String appVersion = '1.1.0';

  static String categoryLabel(String id) {
    for (final category in categories) {
      if (category['id'] == id) return category['label'] as String;
    }
    return id;
  }
}
