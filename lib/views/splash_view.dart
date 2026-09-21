import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_app/routes/app_pages.dart';
import 'package:news_app/services/storage_service.dart';
import 'package:news_app/utils/app_colors.dart';

/// Layar pembuka singkat: brand "Kabar." lalu menuju landing
/// (pengguna baru) atau langsung beranda (pengguna lama).
class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slide = Tween(begin: const Offset(0, .25), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();

    Future.delayed(const Duration(milliseconds: 1700), () {
      final onboarded = Get.find<StorageService>().onboardingDone;
      Get.offAllNamed(onboarded ? Routes.MAIN : Routes.LANDING);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: FadeTransition(
          opacity: _fade,
          child: SlideTransition(
            position: _slide,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(text: 'Kabar'),
                      TextSpan(
                        text: '.',
                        style: TextStyle(
                          color: AppColors.amber,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  style: TextStyle(
                    fontSize: 52,
                    height: 1,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -.5,
                    color: Colors.white,
                    fontFamily: 'Newsreader',
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  'Berita untuk semua.',
                  style: TextStyle(
                    fontSize: 16,
                    letterSpacing: .3,
                    color: Colors.white.withValues(alpha: .85),
                  ),
                ),
                const SizedBox(height: 48),
                SizedBox(
                  width: 56,
                  child: LinearProgressIndicator(
                    minHeight: 3,
                    borderRadius: BorderRadius.circular(2),
                    backgroundColor: Colors.white.withValues(alpha: .25),
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.amber),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
