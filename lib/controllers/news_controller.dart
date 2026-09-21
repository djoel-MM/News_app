import 'package:get/get.dart';
import 'package:news_app/models/news_article.dart';
import 'package:news_app/services/news_service.dart';
import 'package:news_app/utils/constants.dart';

/// State beranda: sorotan utama (hero) + daftar berita per kategori.
class NewsController extends GetxController {
  final NewsService _newsService = NewsService();

  final _isLoading = false.obs;
  final _articles = <NewsArticle>[].obs;
  final _selectedCategory = Constants.defaultCategory.obs;
  final _error = ''.obs;

  bool get isLoading => _isLoading.value;
  List<NewsArticle> get articles => _articles;
  String get selectedCategory => _selectedCategory.value;
  String get error => _error.value;
  List<Map<String, dynamic>> get categories => Constants.categories;

  /// 4 berita teratas tampil sebagai sorotan (hero carousel).
  List<NewsArticle> get heroArticles =>
      _articles.isEmpty ? _articles : _articles.take(4).toList();

  /// Sisanya tampil sebagai daftar kartu.
  List<NewsArticle> get listArticles =>
      _articles.length <= 4 ? const [] : _articles.skip(4).toList();

  @override
  void onInit() {
    super.onInit();
    fetchTopHeadlines();
  }

  Future<void> fetchTopHeadlines({String? category}) async {
    try {
      _isLoading.value = true;
      _error.value = '';
      final response = await _newsService.getTopHeadlines(
        category: category ?? _selectedCategory.value,
      );
      _articles.value = response.articles;
    } catch (e) {
      _error.value = e.toString();
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> refreshNews() => fetchTopHeadlines();

  void selectCategory(String category) {
    if (_selectedCategory.value != category) {
      _selectedCategory.value = category;
      fetchTopHeadlines(category: category);
    }
  }
}
