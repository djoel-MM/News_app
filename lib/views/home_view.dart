import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_app/controllers/news_controller.dart';
import 'package:news_app/routes/app_pages.dart';
import 'package:news_app/utils/app_colors.dart';
import 'package:news_app/widgets/loading_shimmer.dart';
import 'package:news_app/widgets/news_card.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});

  final NewsController controller = Get.find<NewsController>();
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('News App'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: TextField(
              controller: _searchController,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: 'Cari berita...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                isDense: true,
              ),
              onSubmitted: controller.searchNews,
            ),
          ),
          SizedBox(
            height: 48,
            child: Obx(
              () => ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                scrollDirection: Axis.horizontal,
                itemCount: controller.categories.length,
                itemBuilder: (context, index) {
                  final category = controller.categories[index];
                  final isSelected = controller.selectedCategory == category;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(
                      label: Text(
                        category[0].toUpperCase() + category.substring(1),
                      ),
                      selected: isSelected,
                      onSelected: (_) => controller.selectCategory(category),
                      selectedColor: AppColors.primary,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : AppColors.textSecondary,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      showCheckmark: false,
                    ),
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading) {
                return LoadingShimmer();
              }

              if (controller.error.isNotEmpty && controller.articles.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.cloud_off, size: 48, color: AppColors.textHint),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Text(controller.error, textAlign: TextAlign.center),
                      ),
                      const SizedBox(height: 12),
                      FilledButton(
                        onPressed: controller.refreshNews,
                        child: const Text('Coba Lagi'),
                      ),
                    ],
                  ),
                );
              }

              if (controller.articles.isEmpty) {
                return const Center(child: Text('Tidak ada berita'));
              }

              return RefreshIndicator(
                onRefresh: controller.refreshNews,
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.articles.length,
                  itemBuilder: (context, index) {
                    final article = controller.articles[index];
                    return NewsCard(
                      article: article,
                      onTap: () => Get.toNamed(
                        Routes.NEWS_DETAIL,
                        arguments: article,
                      ),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
