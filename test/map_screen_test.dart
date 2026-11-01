import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pemob/project/app/features/map/map_screen.dart';

void main() {
  testWidgets('MapScreen renders map, search bar, controls, and default weather card', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: MapScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Verify search bar
    expect(find.text('Cari lokasi di peta...'), findsOneWidget);

    // Verify controls
    expect(find.byIcon(Icons.add), findsOneWidget);
    expect(find.byIcon(Icons.remove), findsOneWidget);
    expect(find.byIcon(Icons.my_location), findsOneWidget);

    // Verify floating bottom weather card default is Jakarta
    expect(find.text('Jakarta, ID'), findsOneWidget);
    expect(find.text('31.4°C'), findsOneWidget);
    expect(find.text('Berawan'), findsOneWidget);
    expect(find.text('Kelembapan'), findsOneWidget);
    expect(find.text('78%'), findsOneWidget);
    expect(find.text('Angin'), findsOneWidget);
    expect(find.text('3.2 m/s'), findsOneWidget);
    expect(find.text('ISPU'), findsOneWidget);
    expect(find.text('62'), findsOneWidget);

    // Verify closing the card
    final closeBtn = find.byIcon(Icons.close);
    await tester.tap(closeBtn);
    await tester.pumpAndSettle();

    // After closing, bottom card details should not be shown
    expect(find.text('Kelembapan'), findsNothing);
  });

  testWidgets('MapScreen search location updates card', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: MapScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Search for Surabaya
    final searchInput = find.byType(TextField);
    await tester.enterText(searchInput, 'Surabaya');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();

    expect(find.text('Surabaya, ID'), findsOneWidget);
    expect(find.text('34.1°C'), findsOneWidget);
  });
}
