import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:news_app/bindings/app_bindings.dart';
import 'package:news_app/controllers/settings_controller.dart';
import 'package:news_app/routes/app_pages.dart';
import 'package:news_app/utils/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Muat environment variables (API key).
  await dotenv.load(fileName: 'assets/.env');

  // Waktu relatif dalam bahasa Indonesia: "5 menit lalu".
  timeago.setLocaleMessages('id', timeago.IdMessages());
  timeago.setDefaultLocale('id');

  // Penyimpanan lokal harus siap sebelum controller membacanya.
  final prefs = await SharedPreferences.getInstance();
  Get.put<SharedPreferences>(prefs, permanent: true);

  // Daftarkan layanan & controller global sebelum UI dibangun.
  AppBindings().dependencies();

  runApp(const KabarApp());
}

class KabarApp extends StatelessWidget {
  const KabarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final settings = Get.find<SettingsController>();
      return GetMaterialApp(
        title: 'Kabar — Berita untuk semua',
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        themeMode: settings.themeMode.value,
        initialRoute: AppPages.INITIAL,
        getPages: AppPages.routes,
        debugShowCheckedModeBanner: false,
        builder: (context, child) {
          final media = MediaQuery.of(context);
          // Faktor teks = setelan OS × setelan aplikasi, dibatasi agar
          // layout tetap utuh namun teks selalu cukup besar.
          final osFactor = media.textScaler.scale(100) / 100;
          final factor = (osFactor * settings.scale.value).clamp(0.8, 2.2);
          return MediaQuery(
            data: media.copyWith(textScaler: TextScaler.linear(factor)),
            child: child!,
          );
        },
      );
    });
  }
}
