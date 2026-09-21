import 'package:flutter/material.dart';

/// Judul seksi dengan garis aksen pendek — bahasa visual "eyebrow"
/// yang dipakai konsisten di seluruh aplikasi.
class SectionHeader extends StatelessWidget {
  final String title;
  final Widget? trailing;

  const SectionHeader({super.key, required this.title, this.trailing});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 22,
            height: 4,
            decoration: BoxDecoration(
              color: scheme.primary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            title.toUpperCase(),
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.4,
              color: scheme.onSurface,
            ),
          ),
          const Spacer(),
          ?trailing,
        ],
      ),
    );
  }
}
