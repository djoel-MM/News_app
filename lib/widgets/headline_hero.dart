import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:news_app/models/news_article.dart';
import 'package:news_app/utils/format.dart';

/// Sorotan utama: carousel kartu besar di atas beranda.
/// Judul serif besar di atas gambar dengan gradasi tinta.
class HeadlineHero extends StatefulWidget {
  final List<NewsArticle> articles;
  final ValueChanged<NewsArticle> onTap;

  const HeadlineHero({
    super.key,
    required this.articles,
    required this.onTap,
  });

  @override
  State<HeadlineHero> createState() => _HeadlineHeroState();
}

class _HeadlineHeroState extends State<HeadlineHero> {
  final _page = PageController(viewportFraction: .92);
  final _current = 0.obs;

  @override
  void dispose() {
    _page.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        SizedBox(
          height: 380,
          child: PageView.builder(
            controller: _page,
            itemCount: widget.articles.length,
            onPageChanged: (i) => _current.value = i,
            itemBuilder: (context, index) {
              final article = widget.articles[index];
              return Padding(
                padding: EdgeInsets.only(
                  right: index == widget.articles.length - 1 ? 0 : 14,
                ),
                child: _HeroCard(article: article, onTap: () => widget.onTap(article)),
              );
            },
          ),
        ),
        const SizedBox(height: 14),
        Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.articles.length, (i) {
              final active = i == _current.value;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: active ? 22 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: active ? scheme.primary : scheme.outlineVariant,
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}

class _HeroCard extends StatelessWidget {
  final NewsArticle article;
  final VoidCallback onTap;

  const _HeroCard({required this.article, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final published = Format.tryParseDate(article.publishedAt);

    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: Material(
        color: scheme.surfaceContainerHighest,
        child: InkWell(
          onTap: onTap,
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (article.urlToImage != null)
                CachedNetworkImage(
                  imageUrl: article.urlToImage!,
                  fit: BoxFit.cover,
                  placeholder: (_, _) => const SizedBox.expand(),
                  errorWidget: (_, _, _) => const SizedBox.expand(),
                ),
              // Gradasi agar teks putih selalu terbaca di atas gambar apa pun.
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.35, 1.0],
                    colors: [Colors.transparent, Color(0xE616232E)],
                  ),
                ),
              ),
              Positioned(
                left: 20,
                right: 20,
                bottom: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 26,
                          height: 4,
                          decoration: BoxDecoration(
                            color: scheme.secondary,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Flexible(
                          child: Text(
                            article.sourceName.toUpperCase(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
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
                              color: Colors.white.withValues(alpha: .75),
                              fontSize: 12.5,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      article.cleanTitle,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                        height: 1.3,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -.2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
