import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pemob/project/app/features/home/home_screen.dart';

void main() {
  testWidgets('HomeScreen renders live weather and favorites', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: HomeScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Verify Live Conditions card
    expect(find.text('LIVE CONDITIONS'), findsOneWidget);
    expect(find.text('Jakarta, ID'), findsOneWidget);
    expect(find.text('31.4°C'), findsOneWidget);
    expect(find.text('Berawan'), findsWidgets);

    // Verify Analisis Risiko Cuaca
    expect(find.text('Analisis Risiko Cuaca'), findsOneWidget);
    expect(find.text('SEDANG'), findsWidgets);

    // Verify Kualitas Udara
    expect(find.text('Kualitas Udara (ISPU)'), findsOneWidget);
    expect(find.text('62'), findsOneWidget);

    // Verify Prakiraan
    expect(find.text('Prakiraan Per 3 Jam'), findsOneWidget);
    expect(find.text('Prakiraan 5 Hari'), findsOneWidget);

    // Verify Kota Favorit
    expect(find.text('Kota Favorit'), findsOneWidget);
    expect(find.text('Bandung, ID'), findsOneWidget);
    expect(find.text('Surabaya, ID'), findsOneWidget);
    expect(find.text('Medan, ID'), findsOneWidget);
  });

  testWidgets('HomeScreen search updates live condition and handles unknown city', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: HomeScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Search for Bandung
    final searchInput = find.byType(TextField);
    await tester.enterText(searchInput, 'Bandung');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();

    // Now Live Conditions should show Bandung, ID with 24.8°C
    expect(find.text('Bandung, ID'), findsWidgets);
    expect(find.text('24.8°C'), findsWidgets);

    // Search for unknown city
    await tester.enterText(searchInput, 'Atlantis');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();

    expect(find.text('Kota tidak ditemukan'), findsOneWidget);
  });
}


