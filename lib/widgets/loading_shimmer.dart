import 'package:flutter/material.dart';

/// Kerangka pemuatan: meniru tata letak beranda (blok sorotan + kartu)
/// supaya pergantian dari loading ke konten tidak menggeser layout.
class LoadingShimmer extends StatefulWidget {
  const LoadingShimmer({super.key});

  @override
  State<LoadingShimmer> createState() => _LoadingShimmerState();
}

class _LoadingShimmerState extends State<LoadingShimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1400),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final base = scheme.surfaceContainerHighest;
    final highlight = scheme.surface;

    Widget block({double? width, double? height, double radius = 10}) {
      return AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final t = _controller.value;
          return Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(radius),
              gradient: LinearGradient(
                begin: Alignment(-2 + 3 * t, 0),
                end: Alignment(2 * t, 0),
                colors: [base, highlight, base],
              ),
            ),
          );
        },
      );
    }

    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(20),
      children: [
        block(height: 360, radius: 22),
        const SizedBox(height: 28),
        for (var i = 0; i < 5; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 18),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      block(width: 110, height: 12),
                      const SizedBox(height: 10),
                      block(height: 15),
                      const SizedBox(height: 8),
                      block(width: 180, height: 15),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                block(width: 92, height: 92, radius: 14),
              ],
            ),
          ),
      ],
    );
  }
}
