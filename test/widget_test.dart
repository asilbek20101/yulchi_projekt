import 'package:flutter_test/flutter_test.dart';
import 'package:meta_ai_projekt/main.dart';

void main() {
  testWidgets('Yulchi Taxi ilovasi ishga tushadi', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Yulchi Taxi'), findsOneWidget);
    expect(find.text('JIZZAX'), findsOneWidget);
  });
}
