import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pemob/project/app/main.dart';

void main() {
  testWidgets('App smoke test starts on login screen', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: WeatherInsightApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('WeatherInsight'), findsWidgets);
    expect(find.text('Masuk →'), findsOneWidget);
    expect(find.text('Masuk dengan Google'), findsOneWidget);
  });
}

