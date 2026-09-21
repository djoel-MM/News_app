/// Util format kecil: waktu relatif & penanda berita segar.
class Format {
  Format._();

  /// Mengembalikan objek DateTime dari string ISO, atau null bila gagal.
  static DateTime? tryParseDate(String? iso) {
    if (iso == null || iso.isEmpty) return null;
    return DateTime.tryParse(iso)?.toLocal();
  }

  /// Berita dianggap "BARU" bila terbit dalam 3 jam terakhir.
  static bool isFresh(String? publishedAt) {
    final date = tryParseDate(publishedAt);
    if (date == null) return false;
    return DateTime.now().difference(date).inHours < 3;
  }
}
