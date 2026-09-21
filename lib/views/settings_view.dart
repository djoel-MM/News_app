import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_app/controllers/settings_controller.dart';
import 'package:news_app/utils/app_colors.dart';
import 'package:news_app/utils/constants.dart';
import 'package:news_app/widgets/section_header.dart';

/// Tab "Setelan": mode tema, ukuran teks (aksesibilitas inti),
/// dan informasi aplikasi.
class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
        children: [
          Text.rich(
            TextSpan(
              children: [
                const TextSpan(text: Constants.appName),
                TextSpan(text: '.', style: TextStyle(color: AppColors.amber)),
              ],
            ),
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w600,
              letterSpacing: -.5,
              color: scheme.onSurface,
              fontFamily: 'Newsreader',
            ),
          ),
          const SizedBox(height: 28),
          const SectionHeader(title: 'Tampilan'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.brightness_6_outlined,
                          size: 22, color: scheme.onSurfaceVariant),
                      const SizedBox(width: 12),
                      Text('Mode tema',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: scheme.onSurface)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Obx(
                    () => SegmentedButton<ThemeMode>(
                      segments: const [
                        ButtonSegment(
                          value: ThemeMode.system,
                          icon: Icon(Icons.settings_suggest_outlined, size: 20),
                          label: Text('Sistem'),
                        ),
                        ButtonSegment(
                          value: ThemeMode.light,
                          icon: Icon(Icons.light_mode_outlined, size: 20),
                          label: Text('Terang'),
                        ),
                        ButtonSegment(
                          value: ThemeMode.dark,
                          icon: Icon(Icons.dark_mode_outlined, size: 20),
                          label: Text('Gelap'),
                        ),
                      ],
                      selected: {controller.themeMode.value},
                      onSelectionChanged: (selection) =>
                          controller.setThemeMode(selection.first),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          const SectionHeader(title: 'Keterbacaan'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.format_size,
                          size: 22, color: scheme.onSurfaceVariant),
                      const SizedBox(width: 12),
                      Text('Ukuran teks',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: scheme.onSurface)),
                      const Spacer(),
                      Obx(
                        () => Text(
                          '${(controller.scale.value * 100).round()}%',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: scheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  // Pratinjau langsung: pengguna melihat hasil sebelum membaca.
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: scheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Obx(
                      () => Text(
                        'Beginilah tampilan teks berita nanti.',
                        style: TextStyle(
                          fontSize: 15 * controller.scale.value,
                          height: 1.5,
                          color: scheme.onSurface,
                        ),
                      ),
                    ),
                  ),
                  Obx(
                    () => Slider(
                      value: controller.scale.value,
                      min: SettingsController.minScale,
                      max: SettingsController.maxScale,
                      divisions: 5,
                      label: 'Aa',
                      onChanged: controller.setScale,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('A — kecil',
                          style: TextStyle(
                              fontSize: 13, color: scheme.onSurfaceVariant)),
                      Text('besar — A',
                          style: TextStyle(
                              fontSize: 16,
                              color: scheme.onSurfaceVariant,
                              fontWeight: FontWeight.w700)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          const SectionHeader(title: 'Tentang'),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.newspaper_outlined,
                      size: 24, color: scheme.onSurfaceVariant),
                  title: const Text('Nama aplikasi'),
                  trailing: Text(Constants.appName,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: scheme.onSurfaceVariant)),
                ),
                Divider(height: 1, indent: 56, color: scheme.outlineVariant),
                ListTile(
                  leading: Icon(Icons.tag,
                      size: 24, color: scheme.onSurfaceVariant),
                  title: const Text('Versi'),
                  trailing: Text(Constants.appVersion,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: scheme.onSurfaceVariant)),
                ),
                Divider(height: 1, indent: 56, color: scheme.outlineVariant),
                ListTile(
                  leading: Icon(Icons.language,
                      size: 24, color: scheme.onSurfaceVariant),
                  title: const Text('Sumber berita'),
                  trailing: Text('NewsAPI',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: scheme.onSurfaceVariant)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
