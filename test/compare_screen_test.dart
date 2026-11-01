import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pemob/project/app/features/compare/compare_screen.dart';

void main() {
  testWidgets('CompareScreen renders 2 cities and summary', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: CompareScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Verify Title & Dropdowns
    expect(find.text('Pilih 2 Kota untuk Dibandingkan'), findsOneWidget);
    expect(find.text('KOTA A'), findsOneWidget);
    expect(find.text('KOTA B'), findsOneWidget);

    // Verify Default City Cards (Jakarta vs Bandung)
    expect(find.text('Jakarta, ID'), findsOneWidget);
    expect(find.text('Bandung, ID'), findsOneWidget);
    expect(find.text('31.4°C'), findsOneWidget);
    expect(find.text('24.8°C'), findsOneWidget);

    // Verify Summary Card
    expect(find.text('Ringkasan Perbandingan'), findsOneWidget);
    expect(find.text('Jakarta lebih panas 6.6°C dibanding Bandung'), findsOneWidget);
    expect(find.text('Kualitas udara Bandung lebih baik (selisih 24 poin)'), findsOneWidget);
  });

  testWidgets('CompareScreen prevents selecting the same city', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: CompareScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Tap first dropdown (Kota A is Jakarta), try to select Bandung (which is Kota B)
    final dropdowns = find.byType(DropdownButton<String>);
    await tester.tap(dropdowns.first);
    await tester.pumpAndSettle();

    // Tap 'Bandung' in the dropdown menu
    await tester.tap(find.text('Bandung').last);
    await tester.pumpAndSettle();

    // Verify SnackBar message appears
    expect(find.text('Pilih kota yang berbeda'), findsOneWidget);
  });
}
