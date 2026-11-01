import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pemob/project/app/data/models/weather_rule.dart';
import 'package:pemob/project/app/data/providers.dart';
import 'package:pemob/project/app/features/admin/weather_rules_screen.dart';

void main() {
  testWidgets('WeatherRulesScreen renders banner, 3 rules, and edit dialog works',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    final container = ProviderContainer();
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: WeatherRulesScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Verify Title & Banner
    expect(find.text('Aturan Cuaca'), findsOneWidget);
    expect(find.text('Aturan ini menentukan klasifikasi risiko cuaca yang tampil di sisi pengguna secara otomatis.'), findsOneWidget);

    // Verify 3 Rule Cards
    expect(find.text('RENDAH'), findsOneWidget);
    expect(find.text('SEDANG'), findsOneWidget);
    expect(find.text('TINGGI'), findsOneWidget);

    // Tap edit button on Sedang card (index 1 of edit icon buttons)
    final editIcons = find.byIcon(Icons.edit_outlined);
    expect(editIcons, findsNWidgets(3));
    await tester.tap(editIcons.at(1));
    await tester.pumpAndSettle();

    // Verify Edit Dialog opened
    expect(find.text('Edit Rentang Suhu'), findsOneWidget);
    expect(find.text('Tingkat Sedang (TINGKAT 2)'), findsOneWidget);

    // Enter invalid min > max
    final textFields = find.byType(TextField);
    await tester.enterText(textFields.first, '40.0');
    await tester.enterText(textFields.last, '30.0');
    await tester.tap(find.text('Simpan'));
    await tester.pumpAndSettle();

    // Verify error message
    expect(find.text('Suhu minimum harus lebih kecil dari suhu maksimum'), findsOneWidget);

    // Enter valid min & max
    await tester.enterText(textFields.first, '21.0');
    await tester.enterText(textFields.last, '34.0');
    await tester.tap(find.text('Simpan'));
    await tester.pumpAndSettle();

    // Verify dialog closed and SnackBar shown
    expect(find.text('Edit Rentang Suhu'), findsNothing);
    expect(find.text('Aturan berhasil diperbarui'), findsOneWidget);

    // Verify state was updated in provider
    final updatedRules = container.read(weatherRulesProvider);
    final medRule = updatedRules.firstWhere((r) => r.level == RiskLevel.sedang);
    expect(medRule.minTemp, 21.0);
    expect(medRule.maxTemp, 34.0);
  });
}
