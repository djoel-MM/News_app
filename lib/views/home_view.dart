import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_app/controllers/main_controller.dart';
import 'package:news_app/controllers/news_controller.dart';
import 'package:news_app/routes/app_pages.dart';
import 'package:news_app/utils/app_colors.dart';
import 'package:news_app/utils/constants.dart';
import 'package:news_app/widgets/category_chip.dart';
import 'package:news_app/widgets/empty_state.dart';
import 'package:news_app/widgets/headline_hero.dart';
import 'package:news_app/widgets/loading_shimmer.dart';
import 'package:news_app/widgets/news_card.dart';
import 'package:news_app/widgets/section_header.dart';

/// Beranda: sorotan utama, pilihan kategori, dan daftar berita terbaru.
class HomeView extends GetView<NewsController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return SafeArea(
      bottom: false,
      child: Obx(() {
        if (controller.isLoading && controller.articles.isEmpty) {
          return const LoadingShimmer();
        }
        if (controller.error.isNotEmpty && controller.articles.isEmpty) {
          return EmptyState(
            icon: Icons.wifi_off_outlined,
            title: 'Berita tidak dapat dimuat',
            message: 'Periksa koneksi internet Anda, lalu coba lagi.',
            actionLabel: 'Coba Lagi',
            onAction: controller.refreshNews,
          );
        }
        if (controller.articles.isEmpty) {
          return EmptyState(
            icon: Icons.newspaper_outlined,
            title: 'Belum ada berita',
            message: 'Tarik layar ke bawah nanti untuk memuat ulang.',
            actionLabel: 'Muat Ulang',
            onAction: controller.refreshNews,
          );
        }

        return RefreshIndicator(
          onRefresh: controller.refreshNews,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(0, 8, 0, 24),
            children: [
              _Header(scheme: scheme),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SectionHeader(title: 'Sorotan Utama'),
              ),
              HeadlineHero(
                articles: controller.heroArticles,
                onTap: (a) => Get.toNamed(Routes.detail, arguments: a),
              ),
              const SizedBox(height: 28),
              SizedBox(
                height: 48,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: controller.categories.length,
                  itemBuilder: (context, index) {
                    final category = controller.categories[index];
                    return CategoryChip(
                      icon: category['icon'] as IconData,
                      label: category['label'] as String,
                      isSelected: controller.selectedCategory == category['id'],
                      onTap: () => controller.selectCategory(category['id'] as String),
                    );
                  },
                ),
              ),
              const SizedBox(height: 28),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SectionHeader(
                  title:
                      'Terbaru · ${Constants.categoryLabel(controller.selectedCategory)}',
                ),
              ),
              if (controller.listArticles.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: 24),
                  child: EmptyState(
                    icon: Icons.inbox_outlined,
                    title: 'Berita untuk kategori ini belum tersedia',
                    message: 'Coba pilih kategori lain di atas.',
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: controller.listArticles
                        .map((article) => NewsCard(
                              article: article,
                              onTap: () =>
                                  Get.toNamed(Routes.detail, arguments: article),
                            ))
                        .toList(),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }
}

class _Header extends StatelessWidget {
  final ColorScheme scheme;
  const _Header({required this.scheme});

  @override
  Widget build(BuildContext context) {
    final main = Get.find<MainController>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Text.rich(
            TextSpan(
              children: [
                const TextSpan(text: Constants.appName),
                TextSpan(text: '.', style: TextStyle(color: AppColors.amber)),
              ],
            ),
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w600,
              letterSpacing: -.5,
              color: scheme.onSurface,
              fontFamily: 'Newsreader',
            ),
          ),
          const Spacer(),
          // Aksi ikon tetap diberi label tooltip agar terbaca pembaca layar.
          IconButton(
            tooltip: 'Cari berita',
            icon: const Icon(Icons.search, size: 26),
            onPressed: () => main.changeTab(1),
          ),
          IconButton(
            tooltip: 'Pengaturan',
            icon: const Icon(Icons.settings_outlined, size: 26),
            onPressed: () => main.changeTab(3),
          ),
        ],
      ),
    );
  }
}
