import 'package:flutter_test/flutter_test.dart';

import 'package:pdf_analyzer_app/main.dart';

void main() {
  testWidgets('app renders the main StudySmart shell', (WidgetTester tester) async {
    await tester.pumpWidget(const PDFAnalyzerApp());

    expect(find.text('StudySmart'), findsWidgets);
    expect(find.text('PDF\'leri Yükle'), findsOneWidget);
  });
}
