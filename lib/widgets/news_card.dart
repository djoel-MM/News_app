import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:news_app/controllers/bookmark_controller.dart';
import 'package:news_app/models/news_article.dart';
import 'package:news_app/utils/format.dart';

/// Kartu berita kompak untuk daftar & hasil pencarian.
class NewsCard extends StatelessWidget {
  final NewsArticle article;
  final VoidCallback onTap;

  const NewsCard({super.key, required this.article, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final controller = Get.find<BookmarkController>();
    final published = Format.tryParseDate(article.publishedAt);

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            article.sourceName,
                            style: TextStyle(
                              color: scheme.primary,
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                              letterSpacing: .3,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (published != null) ...[
                          const SizedBox(width: 6),
                          Text('·', style: TextStyle(color: scheme.onSurfaceVariant)),
                          const SizedBox(width: 6),
                          Text(
                            timeago.format(published),
                            style: TextStyle(
                              color: scheme.onSurfaceVariant,
                              fontSize: 12.5,
                            ),
                          ),
                        ],
                        const SizedBox(width: 6),
                        if (Format.isFresh(article.publishedAt))
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                            decoration: BoxDecoration(
                              color: scheme.errorContainer,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'BARU',
                              style: TextStyle(
                                color: scheme.onErrorContainer,
                                fontSize: 10.5,
                                fontWeight: FontWeight.w800,
                                letterSpacing: .8,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      article.cleanTitle,
                      style: TextStyle(
                        fontSize: 16.5,
                        fontWeight: FontWeight.w700,
                        height: 1.35,
                        color: scheme.onSurface,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),
                    Obx(
                      () => _BookmarkButton(
                        isSaved: controller.isSaved(article.url),
                        onTap: () => controller.toggle(article),
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              _Thumbnail(article: article, size: 96),
            ],
          ),
        ),
      ),
    );
  }
}

class _Thumbnail extends StatelessWidget {
  final NewsArticle article;
  final double size;

  const _Thumbnail({required this.article, required this.size});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: SizedBox(
        width: size,
        height: size,
        child: article.urlToImage != null
            ? CachedNetworkImage(
                imageUrl: article.urlToImage!,
                fit: BoxFit.cover,
                fadeInDuration: const Duration(milliseconds: 200),
                placeholder: (_, _) =>
                    Container(color: scheme.surfaceContainerHighest),
                errorWidget: (_, _, _) => Container(
                  color: scheme.surfaceContainerHighest,
                  child: Icon(Icons.image_outlined, size: 28, color: scheme.onSurfaceVariant),
                ),
              )
            : Container(
                color: scheme.surfaceContainerHighest,
                child: Icon(Icons.article_outlined, size: 28, color: scheme.onSurfaceVariant),
              ),
      ),
    );
  }
}

class _BookmarkButton extends StatelessWidget {
  final bool isSaved;
  final VoidCallback onTap;
  final Color color;

  const _BookmarkButton({
    required this.isSaved,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: isSaved ? 'Hapus dari tersimpan' : 'Simpan berita',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          // Tinggi sentuh 48 agar mudah disentuh siapa pun;
          // lebar mengikuti isi agar tidak overflow.
          height: 48,
          alignment: Alignment.centerLeft,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isSaved ? Icons.bookmark : Icons.bookmark_border,
                size: 24,
                color: isSaved ? Theme.of(context).colorScheme.primary : color,
              ),
              const SizedBox(width: 8),
              Text(
                isSaved ? 'Tersimpan' : 'Simpan',
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: isSaved
                      ? Theme.of(context).colorScheme.primary
                      : color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
