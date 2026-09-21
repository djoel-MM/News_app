import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_app/utils/app_colors.dart';

/// Tema aplikasi. Headline memakai Newsreader (serif editorial),
/// teks antarmuka memakai Public Sans (dirancang untuk kejelasan
/// informasi publik). Ukuran dasar sengaja lebih besar dari bawaan
/// agar nyaman dibaca lintas generasi.
class AppTheme {
  AppTheme._();

  static TextTheme _textTheme({
    required Color display,
    required Color body,
  }) {
    final serif = GoogleFonts.newsreader().copyWith(color: display);
    final sans = GoogleFonts.publicSans().copyWith(color: body);

    return TextTheme(
      displaySmall: serif.copyWith(
          fontSize: 40, height: 1.12, fontWeight: FontWeight.w500),
      headlineLarge: serif.copyWith(
          fontSize: 30, height: 1.18, fontWeight: FontWeight.w600),
      headlineMedium: serif.copyWith(
          fontSize: 26, height: 1.22, fontWeight: FontWeight.w600),
      headlineSmall: serif.copyWith(
          fontSize: 22, height: 1.26, fontWeight: FontWeight.w600),
      titleLarge:
          sans.copyWith(fontSize: 18, height: 1.35, fontWeight: FontWeight.w700),
      titleMedium: sans.copyWith(
          fontSize: 16, height: 1.4, fontWeight: FontWeight.w700),
      titleSmall:
          sans.copyWith(fontSize: 14, height: 1.4, fontWeight: FontWeight.w700),
      bodyLarge: sans.copyWith(fontSize: 16, height: 1.6),
      bodyMedium: sans.copyWith(fontSize: 15, height: 1.55),
      bodySmall: sans.copyWith(
          fontSize: 13, height: 1.45, color: body.withValues(alpha: .85)),
      labelLarge: sans.copyWith(
          fontSize: 15, height: 1.2, fontWeight: FontWeight.w700),
      labelMedium: sans.copyWith(
          fontSize: 13, height: 1.2, fontWeight: FontWeight.w600, letterSpacing: .2),
      labelSmall: sans.copyWith(
          fontSize: 11.5, height: 1.2, fontWeight: FontWeight.w700, letterSpacing: .9),
    );
  }

  static ThemeData light() {
    final scheme = ColorScheme.light(
      primary: AppColors.primary,
      onPrimary: Colors.white,
      primaryContainer: AppColors.primaryContainer,
      onPrimaryContainer: AppColors.onPrimaryContainer,
      secondary: AppColors.amber,
      onSecondary: Colors.white,
      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,
      onSurfaceVariant: AppColors.textSecondary,
      error: AppColors.error,
      onError: Colors.white,
      surfaceContainerHighest: AppColors.chip,
      outlineVariant: AppColors.divider,
    );

    return _base(
      scheme: scheme,
      scaffold: AppColors.background,
      divider: AppColors.divider,
      hint: AppColors.textHint,
    );
  }

  static ThemeData dark() {
    final scheme = ColorScheme.dark(
      primary: AppColors.darkPrimary,
      onPrimary: Color(0xFF06302B),
      primaryContainer: AppColors.darkPrimaryContainer,
      onPrimaryContainer: AppColors.darkOnPrimaryContainer,
      secondary: AppColors.amber,
      onSecondary: Color(0xFF241A00),
      surface: AppColors.darkSurface,
      onSurface: AppColors.darkTextPrimary,
      onSurfaceVariant: AppColors.darkTextSecondary,
      error: AppColors.darkError,
      onError: Color(0xFF3A0A07),
      surfaceContainerHighest: AppColors.darkChip,
      outlineVariant: AppColors.darkDivider,
    );

    return _base(
      scheme: scheme,
      scaffold: AppColors.darkBackground,
      divider: AppColors.darkDivider,
      hint: AppColors.darkTextHint,
    );
  }

  static ThemeData _base({
    required ColorScheme scheme,
    required Color scaffold,
    required Color divider,
    required Color hint,
  }) {
    final textTheme = _textTheme(display: scheme.onSurface, body: scheme.onSurface);

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: scaffold,
      dividerColor: divider,
      splashFactory: InkSparkle.splashFactory,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: scaffold,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: scheme.surface,
        indicatorColor: scheme.primaryContainer,
        height: 72,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            size: 26,
            color: selected ? scheme.onPrimaryContainer : scheme.onSurfaceVariant,
          );
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            fontSize: 12.5,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            color: selected ? scheme.onPrimaryContainer : scheme.onSurfaceVariant,
          );
        }),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          side: WidgetStatePropertyAll(BorderSide(color: divider)),
          textStyle: WidgetStatePropertyAll(textTheme.labelLarge),
          minimumSize: const WidgetStatePropertyAll(Size(0, 48)),
        ),
      ),
      sliderTheme: const SliderThemeData(
        showValueIndicator: ShowValueIndicator.onDrag,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: scheme.inverseSurface,
        contentTextStyle: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: scheme.onInverseSurface,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(0, 56),
          textStyle: textTheme.labelLarge,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(0, 52),
          textStyle: textTheme.labelLarge,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerHighest,
        hintStyle: TextStyle(fontSize: 15.5, color: hint),
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: scheme.primary, width: 2),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: scheme.surfaceContainerHighest,
        labelStyle: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w600, color: scheme.onSurfaceVariant),
        side: BorderSide.none,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      ),
      cardTheme: CardThemeData(
        color: scheme.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: divider),
        ),
      ),
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        minVerticalPadding: 14,
      ),
    );
  }
}
