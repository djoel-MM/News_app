import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_app/services/storage_service.dart';

/// Preferensi tampilan pengguna: ukuran teks & mode tema.
/// Nilai dipakai oleh main.dart (tema) dan halaman Setelan.
class SettingsController extends GetxController {
  final StorageService _storage = Get.find();

  final scale = 1.0.obs;
  final themeMode = ThemeMode.system.obs;

  static const minScale = 0.85;
  static const maxScale = 1.6;

  @override
  void onInit() {
    super.onInit();
    scale.value = _storage.textScale;
    themeMode.value = switch (_storage.themeMode) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  void setScale(double value) {
    scale.value = value.clamp(minScale, maxScale);
    _storage.setTextScale(scale.value);
  }

  void setThemeMode(ThemeMode mode) {
    themeMode.value = mode;
    _storage.setThemeMode(switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      _ => 'system',
    });
  }
}
