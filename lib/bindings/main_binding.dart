import 'package:get/get.dart';
import 'package:news_app/controllers/main_controller.dart';
import 'package:news_app/controllers/news_search_controller.dart';

/// Binding untuk shell navigasi utama.
class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainController>(() => MainController());
    Get.lazyPut<NewsSearchController>(() => NewsSearchController());
  }
}
