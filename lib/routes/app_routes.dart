// ignore_for_file: constant_identifier_names

part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const SPLASH = _Paths.SPLASH;
  static const LANDING = _Paths.LANDING;
  static const MAIN = _Paths.MAIN;
  static const NEWS_DETAIL = _Paths.NEWS_DETAIL;

  // Alias kecil- huruf agar pemanggilan lebih enak dibaca.
  static String get splash => SPLASH;
  static String get landing => LANDING;
  static String get main => MAIN;
  static String get detail => NEWS_DETAIL;
}

abstract class _Paths {
  _Paths._();
  static const SPLASH = '/splash';
  static const LANDING = '/landing';
  static const MAIN = '/main';
  static const NEWS_DETAIL = '/news-detail';
}
