import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_app/controllers/main_controller.dart';
import 'package:news_app/controllers/news_controller.dart';
import 'package:news_app/controllers/news_search_controller.dart';
import 'package:news_app/routes/app_pages.dart';
import 'package:news_app/utils/constants.dart';
import 'package:news_app/widgets/empty_state.dart';
import 'package:news_app/widgets/loading_shimmer.dart';
import 'package:news_app/widgets/news_card.dart';
import 'package:news_app/widgets/section_header.dart';

/// Tab "Cari": kolom pencarian besar, riwayat pencarian, dan
/// jalan pintas menjelajah kategori.
class SearchView extends StatelessWidget {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NewsSearchController>();
    final textController = TextEditingController(text: controller.query.value);
    final scheme = Theme.of(context).colorScheme;

    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
            child: TextField(
              controller: textController,
              textInputAction: TextInputAction.search,
              onSubmitted: controller.search,
              style: const TextStyle(fontSize: 16),
              decoration: InputDecoration(
                hintText: 'Cari topik, peristiwa, atau sumber…',
                prefixIcon: const Padding(
                  padding: EdgeInsets.only(left: 14, right: 10),
                  child: Icon(Icons.search, size: 26),
                ),
                prefixIconConstraints:
                    const BoxConstraints(minWidth: 48, minHeight: 48),
                suffixIcon: Obx(
                  () => controller.query.value.isNotEmpty
                      ? IconButton(
                          tooltip: 'Hapus kata kunci',
                          icon: const Icon(Icons.close, size: 22),
                          onPressed: () {
                            textController.clear();
                            controller.clearQuery();
                          },
                        )
                      : const SizedBox.shrink(),
                ),
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isSearching.value) {
                return const LoadingShimmer();
              }
              if (controller.error.value.isNotEmpty) {
                return EmptyState(
                  icon: Icons.wifi_off_outlined,
                  title: 'Pencarian gagal',
                  message: 'Periksa koneksi internet Anda, lalu coba lagi.',
                  actionLabel: 'Coba Lagi',
                  onAction: () => controller.search(controller.query.value),
                );
              }
              if (controller.hasSearched.value && controller.results.isEmpty) {
                return EmptyState(
                  icon: Icons.search_off,
                  title: 'Tidak ada hasil untuk “${controller.query.value}”',
                  message: 'Coba kata kunci lain yang lebih umum.',
                );
              }
              if (controller.hasSearched.value) {
                return _Results(controller: controller);
              }
              return _Explore(controller: controller, scheme: scheme);
            }),
          ),
        ],
      ),
    );
  }
}

class _Explore extends StatelessWidget {
  final NewsSearchController controller;
  final ColorScheme scheme;

  const _Explore({required this.controller, required this.scheme});

  @override
  Widget build(BuildContext context) {
    final news = Get.find<NewsController>();
    final main = Get.find<MainController>();

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      children: [
        Obx(
          () => controller.recent.isEmpty
              ? const SizedBox.shrink()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SectionHeader(
                      title: 'Pencarian terakhir',
                      trailing: TextButton(
                        onPressed: controller.clearRecent,
                        child: const Text('Hapus semua'),
                      ),
                    ),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: controller.recent
                          .map((q) => InputChip(
                                label: Text(q),
                                onDeleted: () => controller.removeRecent(q),
                                onPressed: () => controller.search(q),
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
        ),
        const SectionHeader(title: 'Jelajahi kategori'),
        Wrap(
          spacing: 10,
          runSpacing: 12,
          children: Constants.categories
              .map((c) => ActionChip(
                    avatar: Icon(c['icon'] as IconData,
                        size: 20, color: scheme.onSurfaceVariant),
                    label: Text(c['label'] as String),
                    onPressed: () {
                      news.selectCategory(c['id'] as String);
                      main.changeTab(0);
                    },
                  ))
              .toList(),
        ),
        const SizedBox(height: 40),
        EmptyState(
          icon: Icons.travel_explore,
          title: 'Cari apa saja yang Anda ingin tahu',
          message:
              'Ketik kata kunci di atas, misalnya “ekonomi”, “piala dunia”, atau nama tokoh.',
        ),
      ],
    );
  }
}

class _Results extends StatelessWidget {
  final NewsSearchController controller;
  const _Results({required this.controller});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      children: [
        SectionHeader(title: 'Hasil untuk “${controller.query.value}”'),
        for (final article in controller.results)
          NewsCard(
            article: article,
            onTap: () => Get.toNamed(Routes.detail, arguments: article),
          ),
      ],
    );
  }
}
