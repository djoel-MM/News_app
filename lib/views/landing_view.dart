import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_app/routes/app_pages.dart';
import 'package:news_app/services/storage_service.dart';
import 'package:news_app/utils/app_colors.dart';
import 'package:news_app/utils/constants.dart';

/// Halaman landing / onboarding untuk pengguna baru.
/// Prinsip low friction: 2 halaman, bisa dilewati, tanpa akun.
class LandingView extends StatefulWidget {
  const LandingView({super.key});

  @override
  State<LandingView> createState() => _LandingViewState();
}

const _features = [
  (
    Icons.format_size,
    'Teks nyaman dibaca',
    'Perbesar huruf sesuai kenyamanan mata Anda. Semua teks mengikuti.',
  ),
  (
    Icons.bookmark_border,
    'Simpan untuk nanti',
    'Tandai berita penting dan temukan kembali dengan mudah.',
  ),
  (
    Icons.dark_mode_outlined,
    'Terang & gelap',
    'Tampilan menyesuaikan waktu baca Anda, siang maupun malam.',
  ),
];

class _LandingViewState extends State<LandingView> {
  final _controller = PageController();
  int _page = 0;

  void _finish() {
    Get.find<StorageService>().completeOnboarding();
    Get.offAllNamed(Routes.MAIN);
  }

  void _next() {
    if (_page == 0) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
      );
    } else {
      _finish();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: _finish,
                style: TextButton.styleFrom(
                  foregroundColor: scheme.onSurfaceVariant,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                ),
                child: const Text('Lewati',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
              ),
            ),
            Expanded(
              child: PageView(
                controller: _controller,
                onPageChanged: (i) => setState(() => _page = i),
                children: [
                  _IntroPage(
                    brand: const _Brand(),
                    title: 'Berita untuk\nsemua.',
                    body:
                        'Baca kabar terbaru dari sumber terpercaya. Tanpa akun, '
                        'tanpa langkah rumit — buka aplikasi, langsung baca.',
                  ),
                  const _FeaturePage(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 28),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(2, (i) {
                      final active = i == _page;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: active ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: active ? scheme.primary : scheme.outlineVariant,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: _next,
                    child: Text(_page == 0 ? 'Lanjut' : 'Mulai Membaca'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IntroPage extends StatelessWidget {
  final Widget brand;
  final String title;
  final String body;

  const _IntroPage({required this.brand, required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 28),
          brand,
          const Spacer(),
          Text(
            title,
            style: TextStyle(
              fontSize: 46,
              height: 1.08,
              fontWeight: FontWeight.w600,
              letterSpacing: -1,
              color: scheme.onSurface,
              fontFamily: 'Newsreader',
            ),
          ),
          const SizedBox(height: 20),
          Text(
            body,
            style: TextStyle(
              fontSize: 16,
              height: 1.6,
              fontWeight: FontWeight.w500,
              color: scheme.onSurface,
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

class _FeaturePage extends StatelessWidget {
  const _FeaturePage();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          const _Brand(small: true),
          const Spacer(),
          for (final (i, f) in _features.indexed) ...[
            if (i > 0) const SizedBox(height: 26),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: scheme.primaryContainer,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Icon(f.$1, size: 26, color: scheme.onPrimaryContainer),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        f.$2,
                        style: TextStyle(
                          fontSize: 17.5,
                          fontWeight: FontWeight.w700,
                          color: scheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        f.$3,
                        style: TextStyle(
                          fontSize: 14.5,
                          height: 1.5,
                          fontWeight: FontWeight.w500,
                          color: scheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
          const Spacer(),
        ],
      ),
    );
  }
}

class _Brand extends StatelessWidget {
  final bool small;
  const _Brand({this.small = false});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(text: Constants.appName),
              TextSpan(
                text: '.',
                style: TextStyle(color: AppColors.amber),
              ),
            ],
          ),
          style: TextStyle(
            fontSize: small ? 22 : 26,
            fontWeight: FontWeight.w600,
            color: scheme.onSurface,
            fontFamily: 'Newsreader',
          ),
        ),
      ],
    );
  }
}
