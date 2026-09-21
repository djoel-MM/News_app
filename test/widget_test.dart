import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:news_app/views/landing_view.dart';

void main() {
  testWidgets('Landing menampilkan pesan utama dan tombol lewati',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const GetMaterialApp(home: LandingView()),
    );
    await tester.pumpAndSettle();

    expect(find.text('Berita untuk\nsemua.'), findsOneWidget);
    expect(find.text('Lewati'), findsOneWidget);
    expect(find.text('Lanjut'), findsOneWidget);
  });
}
