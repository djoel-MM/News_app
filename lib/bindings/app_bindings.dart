import 'package:get/get.dart';
import 'package:news_app/controllers/bookmark_controller.dart';
import 'package:news_app/controllers/news_controller.dart';
import 'package:news_app/controllers/settings_controller.dart';
import 'package:news_app/services/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Binding global: layanan penyimpanan & controller lintas halaman.
class AppBindings implements Bindings {
  @override
  void dependencies() {
    Get.put<StorageService>(StorageService(Get.find<SharedPreferences>()), permanent: true);
    Get.put<SettingsController>(SettingsController(), permanent: true);
    Get.put<BookmarkController>(BookmarkController(), permanent: true);
    Get.put<NewsController>(NewsController(), permanent: true);
  }
}
