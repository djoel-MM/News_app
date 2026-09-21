import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_app/controllers/main_controller.dart';
import 'package:news_app/views/home_view.dart';
import 'package:news_app/views/saved_view.dart';
import 'package:news_app/views/search_view.dart';
import 'package:news_app/views/settings_view.dart';

/// Kerangka utama: 4 tab dalam IndexedStack agar state tiap tab
/// tetap terjaga. Label navigasi selalu tampil agar mudah dipahami
/// oleh pengguna dari kalangan mana pun.
class MainShellView extends StatelessWidget {
  const MainShellView({super.key});

  static const _views = <Widget>[
    HomeView(),
    SearchView(),
    SavedView(),
    SettingsView(),
  ];

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MainController>();

    return Scaffold(
      body: Obx(
        () => IndexedStack(index: controller.tabIndex.value, children: _views),
      ),
      bottomNavigationBar: Obx(
        () => NavigationBar(
          selectedIndex: controller.tabIndex.value,
          onDestinationSelected: controller.changeTab,
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.newspaper_outlined),
              selectedIcon: const Icon(Icons.newspaper),
              label: 'Beranda',
            ),
            NavigationDestination(
              icon: const Icon(Icons.search),
              selectedIcon: const Icon(Icons.search),
              label: 'Cari',
            ),
            NavigationDestination(
              icon: const Icon(Icons.bookmark_border),
              selectedIcon: const Icon(Icons.bookmark),
              label: 'Tersimpan',
            ),
            NavigationDestination(
              icon: const Icon(Icons.settings_outlined),
              selectedIcon: const Icon(Icons.settings),
              label: 'Setelan',
            ),
          ],
        ),
      ),
    );
  }
}
