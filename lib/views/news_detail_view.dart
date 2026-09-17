import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_app/models/news_article.dart';
import 'package:news_app/utils/app_colors.dart';

class NewsDetailView extends StatelessWidget {
  NewsDetailView({super.key});

  final NewsArticle article = Get.arguments as NewsArticle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Berita')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article.urlToImage != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  article.urlToImage!,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 200,
                    color: AppColors.divider,
                    child: const Icon(Icons.broken_image),
                  ),
                ),
              ),
            const SizedBox(height: 16),
            if (article.title != null)
              Text(
                article.title!,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
              ),
            const SizedBox(height: 8),
            Row(
              children: [
                if (article.source?.name != null) ...[
                  Text(
                    article.source!.name!,
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                if (article.publishedAt != null)
                  Expanded(
                    child: Text(
                      article.publishedAt!,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            ),
            const Divider(height: 24),
            if (article.description != null)
              Text(
                article.description!,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  height: 1.4,
                ),
              ),
            const SizedBox(height: 12),
            Text(
              article.content ??
                  'Buka artikel lengkap melalui tombol di bawah untuk membaca seluruh isi berita.',
              style: const TextStyle(height: 1.6),
            ),
            const SizedBox(height: 24),
            if (article.url != null)
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.open_in_new),
                  label: const Text('Baca Artikel Lengkap'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
