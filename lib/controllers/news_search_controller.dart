import 'package:get/get.dart';
import 'package:news_app/models/news_article.dart';
import 'package:news_app/services/news_service.dart';
import 'package:news_app/services/storage_service.dart';

/// Pencarian berita + riwayat pencarian untuk tab "Cari".
class NewsSearchController extends GetxController {
  final NewsService _service = NewsService();
  final StorageService _storage = Get.find();

  final query = ''.obs;
  final results = <NewsArticle>[].obs;
  final isSearching = false.obs;
  final error = ''.obs;
  final recent = <String>[].obs;
  final hasSearched = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadRecent();
  }

  void _loadRecent() => recent.assignAll(_storage.recentSearches);

  Future<void> search(String rawQuery) async {
    final q = rawQuery.trim();
    if (q.isEmpty) return;

    query.value = q;
    try {
      isSearching.value = true;
      error.value = '';
      final response = await _service.searchNews(query: q, sortBy: 'publishedAt');
      results.value = response.articles;
      hasSearched.value = true;
      await _storage.addRecentSearch(q);
      _loadRecent();
    } catch (e) {
      error.value = e.toString();
      results.clear();
    } finally {
      isSearching.value = false;
    }
  }

  void clearQuery() {
    query.value = '';
    results.clear();
    error.value = '';
    hasSearched.value = false;
  }

  Future<void> removeRecent(String q) async {
    await _storage.removeRecentSearch(q);
    _loadRecent();
  }

  Future<void> clearRecent() async {
    await _storage.clearRecentSearches();
    _loadRecent();
  }
}
