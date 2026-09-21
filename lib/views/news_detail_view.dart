import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:share_plus/share_plus.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';
import 'package:news_app/controllers/bookmark_controller.dart';
import 'package:news_app/models/news_article.dart';
import 'package:news_app/utils/format.dart';

/// Halaman detail artikel: fokus membaca dengan tipografi besar,
/// plus aksi simpan, bagikan, salin tautan, dan buka sumber asli.
class NewsDetailView extends StatelessWidget {
  final NewsArticle article = Get.arguments as NewsArticle;
  final BookmarkController _bookmarks = Get.find();

  NewsDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final published = Format.tryParseDate(article.publishedAt);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 320,
            pinned: true,
            backgroundColor: scheme.surface,
            foregroundColor: scheme.onSurface,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  article.urlToImage != null
                      ? CachedNetworkImage(
                          imageUrl: article.urlToImage!,
                          fit: BoxFit.cover,
                          placeholder: (_, _) =>
                              Container(color: scheme.surfaceContainerHighest),
                          errorWidget: (_, _, _) => Container(
                            color: scheme.surfaceContainerHighest,
                            child: Icon(Icons.image_outlined,
                                size: 44, color: scheme.onSurfaceVariant),
                          ),
                        )
                      : Container(
                          color: scheme.surfaceContainerHighest,
                          child: Icon(Icons.article_outlined,
                              size: 44, color: scheme.onSurfaceVariant),
                        ),
                  // Gradasi atas agar tombol kembali terbaca.
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: const [0.0, 0.3],
                        colors: [
                          Colors.black.withValues(alpha: .45),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              Obx(
                () => _ScrimAction(
                  tooltip: _bookmarks.isSaved(article.url)
                      ? 'Hapus dari tersimpan'
                      : 'Simpan berita',
                  icon: _bookmarks.isSaved(article.url)
                      ? Icons.bookmark
                      : Icons.bookmark_border,
                  onTap: () => _bookmarks.toggle(article),
                ),
              ),
              _ScrimAction(
                tooltip: 'Bagikan',
                icon: Icons.share_outlined,
                onTap: _share,
              ),
              const SizedBox(width: 8),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(22, 24, 22, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Eyebrow: sumber + waktu.
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          article.sourceName.toUpperCase(),
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: scheme.primary,
                            fontSize: 12.5,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      if (published != null) ...[
                        const SizedBox(width: 10),
                        Text(
                          timeago.format(published),
                          style: TextStyle(
                            color: scheme.onSurfaceVariant,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    article.cleanTitle,
                    style: TextStyle(
                      fontSize: 27,
                      height: 1.25,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -.4,
                      color: scheme.onSurface,
                      fontFamily: 'Newsreader',
                    ),
                  ),
                  const SizedBox(height: 18),
                  if (article.description != null &&
                      article.description!.isNotEmpty) ...[
                    Text(
                      article.description!,
                      style: TextStyle(
                        fontSize: 17,
                        height: 1.6,
                        fontWeight: FontWeight.w600,
                        color: scheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: scheme.primary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (article.content != null && article.content!.isNotEmpty) ...[
                    Text(
                      _cleanContent(article.content!),
                      style: TextStyle(
                        fontSize: 16.5,
                        height: 1.75,
                        color: scheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 32),
                  ] else ...[
                    Text(
                      'Isi lengkap artikel hanya tersedia di situs aslinya.',
                      style: TextStyle(
                        fontSize: 16.5,
                        height: 1.7,
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                  FilledButton.icon(
                    onPressed: _openInBrowser,
                    icon: const Icon(Icons.open_in_new, size: 20),
                    label: const Text('Baca Artikel Lengkap'),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: _copyLink,
                    icon: const Icon(Icons.link, size: 20),
                    label: const Text('Salin Tautan'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// API NewsAPI memotong isi dengan tanda "… [+NNN chars]".
  static String _cleanContent(String content) {
    final idx = content.indexOf('… [');
    return idx > 0 ? '${content.substring(0, idx).trim()}…' : content;
  }

  void _share() {
    if (article.url != null) {
      SharePlus.instance.share(
        ShareParams(
          text: '${article.cleanTitle}\n\n${article.url!}',
          title: article.cleanTitle,
        ),
      );
    }
  }

  void _copyLink() {
    if (article.url != null) {
      Clipboard.setData(ClipboardData(text: article.url!));
      Get.snackbar('Tautan disalin', 'Tempel di mana saja untuk membagikan.',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> _openInBrowser() async {
    if (article.url == null) return;
    final url = Uri.parse(article.url!);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar('Tautan tidak dapat dibuka',
          'Coba salin tautan dan buka di peramban.',
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}

/// Tombol ikon dengan lingkaran gelap semi transparan agar kontras
/// di atas gambar apa pun, di mode terang maupun gelap.
class _ScrimAction extends StatelessWidget {
  final String tooltip;
  final IconData icon;
  final VoidCallback onTap;

  const _ScrimAction({
    required this.tooltip,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Material(
          color: Colors.black.withValues(alpha: .38),
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: SizedBox(
              width: 44,
              height: 44,
              child: Icon(icon, size: 22, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
