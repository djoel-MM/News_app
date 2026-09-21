import 'package:get/get.dart';
import 'package:news_app/models/news_article.dart';
import 'package:news_app/services/storage_service.dart';

/// Daftar berita tersimpan (bookmark). State reaktif agar ikon
/// bookmark di kartu & halaman detail ikut berubah seketika.
class BookmarkController extends GetxController {
  final StorageService _storage = Get.find();

  final saved = <NewsArticle>[].obs;

  @override
  void onInit() {
    super.onInit();
    reload();
  }

  void reload() => saved.assignAll(_storage.savedArticles);

  bool isSaved(String? url) => saved.any((a) => a.url == url);

  Future<void> toggle(NewsArticle article) async {
    if (isSaved(article.url)) {
      await _storage.removeSaved(article.url!);
      reload();
      Get.snackbar('Dihapus', 'Berita dikeluarkan dari daftar tersimpan.',
          snackPosition: SnackPosition.BOTTOM);
    } else {
      await _storage.addSaved(article);
      reload();
      Get.snackbar('Tersimpan', 'Ketuk Tersimpan di bawah untuk membacanya nanti.',
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}
