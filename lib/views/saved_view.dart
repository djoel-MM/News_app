import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_app/controllers/bookmark_controller.dart';
import 'package:news_app/controllers/main_controller.dart';
import 'package:news_app/routes/app_pages.dart';
import 'package:news_app/widgets/empty_state.dart';
import 'package:news_app/widgets/news_card.dart';
import 'package:news_app/widgets/section_header.dart';

/// Tab "Tersimpan": daftar berita yang ditandai pengguna.
class SavedView extends StatelessWidget {
  const SavedView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BookmarkController>();
    final main = Get.find<MainController>();

    return SafeArea(
      bottom: false,
      child: Obx(() {
        final articles = controller.saved;
        if (articles.isEmpty) {
          return EmptyState(
            icon: Icons.bookmark_border,
            title: 'Belum ada berita tersimpan',
            message:
                'Ketuk “Simpan” pada berita mana pun untuk menyimpannya di sini.',
            actionLabel: 'Jelajahi Berita',
            onAction: () => main.changeTab(0),
          );
        }

        return ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
          children: [
            SectionHeader(title: 'Tersimpan · ${articles.length} berita'),
            for (final article in articles)
              NewsCard(
                article: article,
                onTap: () => Get.toNamed(Routes.detail, arguments: article),
              ),
          ],
        );
      }),
    );
  }
}
