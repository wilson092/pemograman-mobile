import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pemob/project/app/data/models/app_user.dart';
import 'package:pemob/project/app/data/providers.dart';
import 'package:pemob/project/app/features/admin/roles_screen.dart';

void main() {
  testWidgets('RolesScreen renders cards and edits user role properly', (WidgetTester tester) async {
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
          home: RolesScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Verify Title
    expect(find.text('Manajemen Peran'), findsOneWidget);

    // Verify Admin Card
    expect(find.text('Admin'), findsWidgets);
    expect(find.text('Super'), findsOneWidget);
    expect(find.text('2 pengguna'), findsOneWidget);
    expect(find.text('role_id: 1'), findsOneWidget);
    expect(find.text('Akses dashboard admin'), findsOneWidget);
    expect(find.text('Akses Penuh'), findsOneWidget);

    // Verify User Card
    expect(find.text('Aktif'), findsOneWidget);
    expect(find.text('146 pengguna'), findsOneWidget);
    expect(find.text('role_id: 2'), findsOneWidget);
    expect(find.text('Akses fitur cuaca'), findsOneWidget);
    expect(find.text('Baca Saja'), findsOneWidget);

    // Verify Form section
    expect(find.text('Ubah Peran Pengguna'), findsOneWidget);
    expect(find.text('FORM EDIT'), findsOneWidget);

    // Tap Simpan without selecting user
    await tester.tap(find.text('Simpan Peran'));
    await tester.pumpAndSettle();
    expect(find.text('Pilih pengguna terlebih dahulu'), findsOneWidget);

    // Scroll down to form
    await tester.ensureVisible(find.text('Ubah Peran Pengguna'));
    await tester.pumpAndSettle();

    // Select user from dropdown (Andi Pratama)
    final dropdown = find.byType(DropdownButton<int>);
    await tester.ensureVisible(dropdown);
    await tester.pumpAndSettle();
    await tester.tap(dropdown);
    await tester.pumpAndSettle();

    final andiItems = find.text('Andi Pratama (User)');
    await tester.tap(andiItems.last);
    await tester.pumpAndSettle();

    // Switch role radio to Admin
    final adminRadio = find.byType(Radio<UserRole>).first;
    await tester.ensureVisible(adminRadio);
    await tester.pumpAndSettle();
    await tester.tap(adminRadio);
    await tester.pumpAndSettle();

    // Save Role
    final simpanBtn = find.text('Simpan Peran');
    await tester.ensureVisible(simpanBtn);
    await tester.pumpAndSettle();
    await tester.tap(simpanBtn);
    await tester.pumpAndSettle();

    // Verify SnackBar
    expect(find.text('Peran Andi Pratama berhasil diubah menjadi Admin'), findsOneWidget);

    // Verify User list updated
    final updatedUsers = container.read(adminUsersProvider);
    final andi = updatedUsers.firstWhere((u) => u.name == 'Andi Pratama');
    expect(andi.role, UserRole.admin);

    // Verify Counts updated dynamically in the UI
    expect(find.text('3 pengguna'), findsOneWidget);
    expect(find.text('145 pengguna'), findsOneWidget);

    // Verify Activity Log added
    final logs = container.read(activityLogsProvider);
    expect(logs.first.actionCode, 'USER_ROLE_CHANGE');
  });
}
