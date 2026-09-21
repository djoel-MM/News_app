import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:news_app/models/news_article.dart';

/// Wrapper SharedPreferences: bookmark, riwayat pencarian,
/// status onboarding, dan preferensi tampilan.
class StorageService {
  static const _kSaved = 'saved_articles';
  static const _kOnboarded = 'onboarding_done';
  static const _kRecent = 'recent_searches';
  static const _kTextScale = 'text_scale';
  static const _kThemeMode = 'theme_mode';

  final SharedPreferences _prefs;
  StorageService(this._prefs);

  // ---- Onboarding ----
  bool get onboardingDone => _prefs.getBool(_kOnboarded) ?? false;
  Future<void> completeOnboarding() => _prefs.setBool(_kOnboarded, true);

  // ---- Berita tersimpan ----
  List<NewsArticle> get savedArticles =>
      (_prefs.getStringList(_kSaved) ?? [])
          .map((e) => NewsArticle.fromJson(jsonDecode(e)))
          .toList();

  Future<void> _writeSaved(List<NewsArticle> articles) =>
      _prefs.setStringList(
          _kSaved, articles.map((a) => jsonEncode(a.toJson())).toList());

  bool isSaved(String? url) =>
      url != null && savedArticles.any((a) => a.url == url);

  Future<void> addSaved(NewsArticle article) async {
    final list = savedArticles..removeWhere((a) => a.url == article.url);
    await _writeSaved([article, ...list]);
  }

  Future<void> removeSaved(String url) async {
    final list = savedArticles..removeWhere((a) => a.url == url);
    await _writeSaved(list);
  }

  // ---- Riwayat pencarian ----
  List<String> get recentSearches => _prefs.getStringList(_kRecent) ?? [];

  Future<void> addRecentSearch(String query) async {
    final q = query.trim();
    if (q.isEmpty) return;
    final list = recentSearches..removeWhere((e) => e.toLowerCase() == q.toLowerCase());
    await _prefs.setStringList(_kRecent, [q, ...list].take(8).toList());
  }

  Future<void> removeRecentSearch(String query) async {
    final list = recentSearches..removeWhere((e) => e == query);
    await _prefs.setStringList(_kRecent, list);
  }

  Future<void> clearRecentSearches() => _prefs.setStringList(_kRecent, []);

  // ---- Preferensi tampilan ----
  double get textScale => _prefs.getDouble(_kTextScale) ?? 1.0;
  Future<void> setTextScale(double value) => _prefs.setDouble(_kTextScale, value);

  String get themeMode => _prefs.getString(_kThemeMode) ?? 'system';
  Future<void> setThemeMode(String value) => _prefs.setString(_kThemeMode, value);
}
