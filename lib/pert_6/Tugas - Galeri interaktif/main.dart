import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ===================== Tema (disimpan) =====================

final themeMode = ValueNotifier<ThemeMode>(ThemeMode.light);
final seedColor = ValueNotifier<Color>(Colors.indigo);
final favorit = ValueNotifier<Set<String>>(<String>{});

const List<Color> pilihanWarna = [
  Colors.indigo,
  Colors.teal,
  Colors.deepOrange,
  Colors.pink,
];

ThemeData buatTema(Color seed, Brightness brightness) {
  return ThemeData(
    useMaterial3: true,
    colorSchemeSeed: seed,
    brightness: brightness,
    appBarTheme: const AppBarTheme(centerTitle: true),
  );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  themeMode.value =
      (prefs.getBool('gelap') ?? false) ? ThemeMode.dark : ThemeMode.light;
  final idx = (prefs.getInt('warna') ?? 0).clamp(0, pilihanWarna.length - 1);
  seedColor.value = pilihanWarna[idx];
  favorit.value = (prefs.getStringList('favorit') ?? <String>[]).toSet();

  // Simpan otomatis setiap nilai berubah
  themeMode.addListener(() {
    prefs.setBool('gelap', themeMode.value == ThemeMode.dark);
  });
  seedColor.addListener(() {
    prefs.setInt('warna', pilihanWarna.indexOf(seedColor.value));
  });
  favorit.addListener(() {
    prefs.setStringList('favorit', favorit.value.toList());
  });

  runApp(const MyApp());
}

void toggleFavorit(String nama) {
  final baru = Set<String>.from(favorit.value);
  if (!baru.remove(nama)) baru.add(nama);
  favorit.value = baru;
}

// ===================== Model & Data =====================

class Planet {
  final String nama;
  final String jenis;
  final String deskripsi;
  final String diameter;
  final String jarak;
  final String periodeOrbit;
  final int jumlahBulan;
  final Color warna; // warna khas planet (data, bukan warna UI)
  final bool bercincin;

  const Planet({
    required this.nama,
    required this.jenis,
    required this.deskripsi,
    required this.diameter,
    required this.jarak,
    required this.periodeOrbit,
    required this.jumlahBulan,
    required this.warna,
    this.bercincin = false,
  });
}

const daftarPlanet = [
  Planet(
    nama: 'Merkurius',
    jenis: 'Planet kebumian',
    deskripsi: 'Planet terkecil dan terdekat dengan Matahari. Suhu siang '
        'sangat panas dan malam sangat dingin karena hampir tanpa atmosfer.',
    diameter: '4.879 km',
    jarak: '57,9 juta km',
    periodeOrbit: '88 hari',
    jumlahBulan: 0,
    warna: Color(0xFF9E9E9E),
  ),
  Planet(
    nama: 'Venus',
    jenis: 'Planet kebumian',
    deskripsi: 'Planet terpanas di tata surya akibat atmosfer tebal yang '
        'memerangkap panas. Venus berotasi berlawanan arah dengan kebanyakan '
        'planet.',
    diameter: '12.104 km',
    jarak: '108,2 juta km',
    periodeOrbit: '225 hari',
    jumlahBulan: 0,
    warna: Color(0xFFE6B15A),
  ),
  Planet(
    nama: 'Bumi',
    jenis: 'Planet kebumian',
    deskripsi: 'Satu-satunya planet yang diketahui memiliki kehidupan. '
        'Sekitar 71% permukaannya tertutup air.',
    diameter: '12.742 km',
    jarak: '149,6 juta km',
    periodeOrbit: '365 hari',
    jumlahBulan: 1,
    warna: Color(0xFF2E7DD1),
  ),
  Planet(
    nama: 'Mars',
    jenis: 'Planet kebumian',
    deskripsi: 'Dijuluki Planet Merah karena kandungan besi oksida di '
        'permukaannya. Memiliki gunung tertinggi di tata surya, Olympus Mons.',
    diameter: '6.779 km',
    jarak: '227,9 juta km',
    periodeOrbit: '687 hari',
    jumlahBulan: 2,
    warna: Color(0xFFC1440E),
  ),
  Planet(
    nama: 'Jupiter',
    jenis: 'Raksasa gas',
    deskripsi: 'Planet terbesar di tata surya. Bintik Merah Besarnya adalah '
        'badai raksasa yang telah berlangsung ratusan tahun.',
    diameter: '139.820 km',
    jarak: '778,5 juta km',
    periodeOrbit: '11,9 tahun',
    jumlahBulan: 95,
    warna: Color(0xFFD9A066),
  ),
  Planet(
    nama: 'Saturnus',
    jenis: 'Raksasa gas',
    deskripsi: 'Terkenal dengan sistem cincinnya yang megah, tersusun dari '
        'es dan batuan. Massa jenisnya lebih kecil daripada air.',
    diameter: '116.460 km',
    jarak: '1,43 miliar km',
    periodeOrbit: '29,5 tahun',
    jumlahBulan: 146,
    warna: Color(0xFFE3C98B),
    bercincin: true,
  ),
  Planet(
    nama: 'Uranus',
    jenis: 'Raksasa es',
    deskripsi: 'Berotasi miring hampir 98 derajat sehingga tampak '
        'menggelinding di orbitnya. Berwarna biru kehijauan karena metana.',
    diameter: '50.724 km',
    jarak: '2,87 miliar km',
    periodeOrbit: '84 tahun',
    jumlahBulan: 28,
    warna: Color(0xFF7DE3E3),
  ),
  Planet(
    nama: 'Neptunus',
    jenis: 'Raksasa es',
    deskripsi: 'Planet terjauh dari Matahari dengan angin tercepat di tata '
        'surya. Berwarna biru pekat.',
    diameter: '49.244 km',
    jarak: '4,50 miliar km',
    periodeOrbit: '165 tahun',
    jumlahBulan: 16,
    warna: Color(0xFF3F54D1),
  ),
];

// Argumen untuk named route. Tag Hero dibedakan per tab agar tidak bentrok.
class DetailArgs {
  final Planet planet;
  final String heroTag;
  const DetailArgs(this.planet, this.heroTag);
}

// ===================== Widget Planet =====================

// Planet digambar sebagai lingkaran bergradasi (+ cincin bila ada)
class PlanetAvatar extends StatelessWidget {
  final Planet planet;
  final double ukuran;
  const PlanetAvatar({super.key, required this.planet, required this.ukuran});

  @override
  Widget build(BuildContext context) {
    final bola = Container(
      width: ukuran,
      height: ukuran,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          center: const Alignment(-0.4, -0.4),
          radius: 0.95,
          colors: [
            Color.lerp(planet.warna, Colors.white, 0.35)!,
            planet.warna,
            Color.lerp(planet.warna, Colors.black, 0.45)!,
          ],
          stops: const [0.0, 0.55, 1.0],
        ),
      ),
    );

    if (!planet.bercincin) return bola;

    // Cincin Saturnus
    return SizedBox(
      width: ukuran * 1.6,
      height: ukuran,
      child: Stack(
        alignment: Alignment.center,
        children: [
          bola,
          Transform.rotate(
            angle: -0.35,
            child: Container(
              width: ukuran * 1.6,
              height: ukuran * 0.35,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: planet.warna.withValues(alpha: 0.8),
                  width: ukuran * 0.07,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ===================== App & Routing =====================

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([themeMode, seedColor]),
      builder: (context, _) {
        return MaterialApp(
          title: 'Katalog Planet',
          debugShowCheckedModeBanner: false,
          theme: buatTema(seedColor.value, Brightness.light),
          darkTheme: buatTema(seedColor.value, Brightness.dark),
          themeMode: themeMode.value,
          initialRoute: '/',
          routes: {
            '/': (_) => const ShellPage(),
          },
          onGenerateRoute: (settings) {
            if (settings.name == '/detail') {
              final args = settings.arguments as DetailArgs;
              return MaterialPageRoute(
                settings: settings,
                builder: (_) => DetailPage(args: args),
              );
            }
            return null;
          },
        );
      },
    );
  }
}

// ===================== Shell (3 Tab) =====================

class ShellPage extends StatefulWidget {
  const ShellPage({super.key});

  @override
  State<ShellPage> createState() => _ShellPageState();
}

class _ShellPageState extends State<ShellPage> {
  int _index = 0;

  static const _halaman = [KatalogTab(), FavoritTab(), PengaturanTab()];
  static const _judul = ['Katalog Planet', 'Favorit', 'Pengaturan'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_judul[_index])),
      body: IndexedStack(index: _index, children: _halaman),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.public_outlined),
            selectedIcon: Icon(Icons.public),
            label: 'Katalog',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border),
            selectedIcon: Icon(Icons.favorite),
            label: 'Favorit',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Pengaturan',
          ),
        ],
      ),
    );
  }
}

// ===================== Widget Bersama =====================

// Kartu satu planet (dipakai di tab Katalog dan Favorit)
class PlanetTile extends StatelessWidget {
  final Planet planet;
  final String tagPrefix;
  const PlanetTile({super.key, required this.planet, required this.tagPrefix});

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final cs = tema.colorScheme;
    final heroTag = '$tagPrefix-${planet.nama}';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: SizedBox(
          width: 64,
          height: 56,
          child: Center(
            child: Hero(
              tag: heroTag,
              child: PlanetAvatar(planet: planet, ukuran: 44),
            ),
          ),
        ),
        title: Text(planet.nama, style: tema.textTheme.titleMedium),
        subtitle: Text(planet.jenis, style: tema.textTheme.bodyMedium),
        trailing: ValueListenableBuilder<Set<String>>(
          valueListenable: favorit,
          builder: (context, set, _) {
            final suka = set.contains(planet.nama);
            // Animasi implisit: ikon hati berganti dengan efek skala
            return IconButton(
              onPressed: () => toggleFavorit(planet.nama),
              icon: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                transitionBuilder: (child, anim) =>
                    ScaleTransition(scale: anim, child: child),
                child: Icon(
                  suka ? Icons.favorite : Icons.favorite_border,
                  key: ValueKey(suka),
                  color: suka ? cs.error : cs.onSurfaceVariant,
                ),
              ),
            );
          },
        ),
        onTap: () {
          Navigator.pushNamed(
            context,
            '/detail',
            arguments: DetailArgs(planet, heroTag),
          );
        },
      ),
    );
  }
}

// ===================== Tab 1: Katalog =====================

class KatalogTab extends StatefulWidget {
  const KatalogTab({super.key});

  @override
  State<KatalogTab> createState() => _KatalogTabState();
}

class _KatalogTabState extends State<KatalogTab>
    with SingleTickerProviderStateMixin {
  // Animasi eksplisit: ikon banner berputar terus-menerus
  late final AnimationController _orbit;

  @override
  void initState() {
    super.initState();
    _orbit = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();
  }

  @override
  void dispose() {
    _orbit.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final cs = tema.colorScheme;

    return ListView(
      padding: const EdgeInsets.only(bottom: 16),
      children: [
        Card(
          margin: const EdgeInsets.all(12),
          color: cs.primaryContainer,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                RotationTransition(
                  turns: _orbit,
                  child: Icon(Icons.public,
                      size: 56, color: cs.onPrimaryContainer),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tata Surya',
                        style: tema.textTheme.titleLarge
                            ?.copyWith(color: cs.onPrimaryContainer),
                      ),
                      Text(
                        '${daftarPlanet.length} planet untuk dijelajahi',
                        style: tema.textTheme.bodyMedium
                            ?.copyWith(color: cs.onPrimaryContainer),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        for (final p in daftarPlanet) PlanetTile(planet: p, tagPrefix: 'katalog'),
      ],
    );
  }
}

// ===================== Tab 2: Favorit =====================

class FavoritTab extends StatelessWidget {
  const FavoritTab({super.key});

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return ValueListenableBuilder<Set<String>>(
      valueListenable: favorit,
      builder: (context, set, _) {
        final data = daftarPlanet.where((p) => set.contains(p.nama)).toList();
        if (data.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.favorite_border,
                    size: 64, color: tema.colorScheme.outline),
                const SizedBox(height: 12),
                Text('Belum ada favorit', style: tema.textTheme.titleMedium),
                Text('Tekan ikon hati di tab Katalog',
                    style: tema.textTheme.bodyMedium),
              ],
            ),
          );
        }
        return ListView(
          padding: const EdgeInsets.symmetric(vertical: 8),
          children: [
            for (final p in data) PlanetTile(planet: p, tagPrefix: 'favorit'),
          ],
        );
      },
    );
  }
}

// ===================== Tab 3: Pengaturan =====================

class PengaturanTab extends StatelessWidget {
  const PengaturanTab({super.key});

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return ListenableBuilder(
      listenable: Listenable.merge([themeMode, seedColor]),
      builder: (context, _) {
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            SwitchListTile(
              title: const Text('Mode gelap'),
              value: themeMode.value == ThemeMode.dark,
              onChanged: (v) {
                themeMode.value = v ? ThemeMode.dark : ThemeMode.light;
              },
            ),
            const SizedBox(height: 8),
            Text('Warna tema', style: tema.textTheme.titleMedium),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              children: [
                for (final c in pilihanWarna)
                  GestureDetector(
                    onTap: () => seedColor.value = c,
                    // Animasi implisit: lingkaran terpilih membesar
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      width: seedColor.value == c ? 52 : 40,
                      height: seedColor.value == c ? 52 : 40,
                      decoration: BoxDecoration(
                        color: c,
                        shape: BoxShape.circle,
                      ),
                      child: seedColor.value == c
                          ? Icon(
                              Icons.check,
                              color: ThemeData.estimateBrightnessForColor(c) ==
                                      Brightness.dark
                                  ? tema.colorScheme.surface
                                  : tema.colorScheme.onSurface,
                            )
                          : null,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'Pengaturan tersimpan otomatis dan tetap ada setelah '
              'aplikasi ditutup.',
              style: tema.textTheme.bodySmall,
            ),
          ],
        );
      },
    );
  }
}

// ===================== Halaman Detail =====================

class DetailPage extends StatelessWidget {
  final DetailArgs args;
  const DetailPage({super.key, required this.args});

  Widget _baris(BuildContext context, IconData ikon, String label, String nilai) {
    final tema = Theme.of(context);
    return ListTile(
      leading: Icon(ikon, color: tema.colorScheme.primary),
      title: Text(label, style: tema.textTheme.bodyMedium),
      trailing: Text(nilai, style: tema.textTheme.titleSmall),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final cs = tema.colorScheme;
    final p = args.planet;

    return Scaffold(
      appBar: AppBar(
        title: Text(p.nama),
        actions: [
          ValueListenableBuilder<Set<String>>(
            valueListenable: favorit,
            builder: (context, set, _) {
              final suka = set.contains(p.nama);
              return IconButton(
                tooltip: suka ? 'Hapus dari favorit' : 'Tambah ke favorit',
                onPressed: () => toggleFavorit(p.nama),
                icon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  transitionBuilder: (child, anim) =>
                      ScaleTransition(scale: anim, child: child),
                  child: Icon(
                    suka ? Icons.favorite : Icons.favorite_border,
                    key: ValueKey(suka),
                    color: suka ? cs.error : null,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Center(
            child: Hero(
              tag: args.heroTag,
              child: PlanetAvatar(planet: p, ukuran: 140),
            ),
          ),
          const SizedBox(height: 24),
          Text(p.nama,
              textAlign: TextAlign.center,
              style: tema.textTheme.headlineMedium),
          Text(p.jenis,
              textAlign: TextAlign.center, style: tema.textTheme.titleMedium),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(p.deskripsi, style: tema.textTheme.bodyLarge),
            ),
          ),
          Card(
            child: Column(
              children: [
                _baris(context, Icons.straighten, 'Diameter', p.diameter),
                _baris(context, Icons.wb_sunny_outlined, 'Jarak dari Matahari',
                    p.jarak),
                _baris(context, Icons.loop, 'Periode orbit', p.periodeOrbit),
                _baris(context, Icons.nightlight_outlined, 'Jumlah bulan',
                    '${p.jumlahBulan}'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}