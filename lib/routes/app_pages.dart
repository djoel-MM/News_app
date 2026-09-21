import 'package:get/get.dart';
import 'package:news_app/bindings/main_binding.dart';
import 'package:news_app/views/landing_view.dart';
import 'package:news_app/views/main_shell_view.dart';
import 'package:news_app/views/news_detail_view.dart';
import 'package:news_app/views/splash_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(name: _Paths.SPLASH, page: () => const SplashView()),
    GetPage(name: _Paths.LANDING, page: () => const LandingView()),
    GetPage(name: _Paths.MAIN, page: () => const MainShellView(), binding: MainBinding()),
    GetPage(name: _Paths.NEWS_DETAIL, page: () => NewsDetailView()),
  ];
}
