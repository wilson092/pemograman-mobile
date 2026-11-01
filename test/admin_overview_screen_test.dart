import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pemob/project/app/features/admin/overview_screen.dart';

void main() {
  testWidgets('AdminOverviewScreen renders 4 stat cards, recent activities, and service status',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: AdminOverviewScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Verify Title in AdminTopBar
    expect(find.text('Overview'), findsOneWidget);
    expect(find.text('WEATHERINSIGHT'), findsOneWidget);

    // Verify Stat Cards
    expect(find.text('Total Pengguna'), findsOneWidget);
    expect(find.text('1.248'), findsOneWidget);
    expect(find.text('+12% bulan ini'), findsOneWidget);

    expect(find.text('Aturan Cuaca'), findsOneWidget);
    expect(find.text('3 Aturan'), findsOneWidget);

    expect(find.text('API Calls (24j)'), findsOneWidget);
    expect(find.text('48.2K'), findsOneWidget);

    expect(find.text('Status Sistem'), findsOneWidget);
    expect(find.text('OPERASIONAL'), findsOneWidget);

    // Verify Aktivitas Terakhir
    expect(find.text('Aktivitas Terakhir'), findsOneWidget);
    expect(find.text('Lihat Semua'), findsOneWidget);

    // Verify Service Status Card
    expect(find.text('Status Layanan'), findsOneWidget);
    expect(find.text('OpenWeatherMap API'), findsOneWidget);
    expect(find.text('Database Utama'), findsOneWidget);
    expect(find.text('Cache Layer (Redis)'), findsOneWidget);
    expect(find.text('Background Worker'), findsOneWidget);
  });

  testWidgets('AdminOverviewScreen tap refresh shows SnackBar', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: AdminOverviewScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Tap refresh button
    final refreshBtn = find.byIcon(Icons.refresh);
    expect(refreshBtn, findsOneWidget);
    await tester.tap(refreshBtn);
    await tester.pumpAndSettle();

    // Verify SnackBar
    expect(find.text('Data overview diperbarui'), findsOneWidget);
  });
}
