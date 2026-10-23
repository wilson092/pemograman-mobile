import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'pages/shell_page.dart';
import 'pages/form_kegiatan_page.dart';
import 'state/pengaturan.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  runApp(
    ChangeNotifierProvider(
      create: (_) => PengaturanProvider(),
      child: const TabungKuApp(),
    ),
  );
}

class TabungKuApp extends StatelessWidget {
  const TabungKuApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pengaturan = context.watch<PengaturanProvider>();

    return MaterialApp(
      title: 'TabungKu',
      debugShowCheckedModeBanner: false,
      themeMode: pengaturan.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: pengaturan.getSeedColor(), brightness: Brightness.light),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: pengaturan.getSeedColor(), brightness: Brightness.dark),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const ShellPage(),
        '/form': (context) => const FormKegiatanPage(),
      },
    );
  }
}
