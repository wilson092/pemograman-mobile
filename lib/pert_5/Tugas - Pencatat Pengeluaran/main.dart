import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

// ===================== Konstanta & Util =====================

const List<String> kKategori = [
  'Makanan',
  'Transport',
  'Belanja',
  'Tagihan',
  'Hiburan',
  'Lainnya',
];

// Pengaturan SharedPreferences: mode gelap (dibaca saat aplikasi mulai)
final ValueNotifier<bool> temaGelap = ValueNotifier<bool>(false);

String rupiah(int n) {
  final s = n.toString().replaceAllMapped(
        RegExp(r'\B(?=(\d{3})+(?!\d))'),
        (m) => '.',
      );
  return 'Rp $s';
}

String formatTanggal(DateTime d) =>
    '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

// ===================== Model =====================

class Pengeluaran {
  final int? id;
  final String nama;
  final int jumlah;
  final String kategori;
  final String tanggal;

  const Pengeluaran({
    this.id,
    required this.nama,
    required this.jumlah,
    required this.kategori,
    required this.tanggal,
  });

  Map<String, Object?> toMap() => {
        'id': id,
        'nama': nama,
        'jumlah': jumlah,
        'kategori': kategori,
        'tanggal': tanggal,
      };

  factory Pengeluaran.fromMap(Map<String, Object?> m) => Pengeluaran(
        id: m['id'] as int,
        nama: m['nama'] as String,
        jumlah: m['jumlah'] as int,
        kategori: m['kategori'] as String,
        tanggal: m['tanggal'] as String,
      );
}

// ===================== Akses Data (SQLite) =====================

class DbHelper {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    final path = p.join(await getDatabasesPath(), 'pengeluaran.db');
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE pengeluaran('
          'id INTEGER PRIMARY KEY AUTOINCREMENT, '
          'nama TEXT NOT NULL, '
          'jumlah INTEGER NOT NULL, '
          'kategori TEXT NOT NULL, '
          'tanggal TEXT NOT NULL)',
        );
      },
    );
    return _db!;
  }

  static Future<int> tambah(Pengeluaran x) async {
    final db = await database;
    return db.insert('pengeluaran', x.toMap());
  }

  static Future<List<Pengeluaran>> semua() async {
    final db = await database;
    final rows = await db.query('pengeluaran', orderBy: 'tanggal DESC, id DESC');
    return rows.map(Pengeluaran.fromMap).toList();
  }

  static Future<int> ubah(Pengeluaran x) async {
    final db = await database;
    return db.update('pengeluaran', x.toMap(),
        where: 'id = ?', whereArgs: [x.id]);
  }

  static Future<int> hapus(int id) async {
    final db = await database;
    return db.delete('pengeluaran', where: 'id = ?', whereArgs: [id]);
  }

  // Total memakai SELECT SUM
  static Future<int> total() async {
    final db = await database;
    final hasil =
        await db.rawQuery('SELECT SUM(jumlah) AS total FROM pengeluaran');
    return Sqflite.firstIntValue(hasil) ?? 0;
  }
}

// ===================== App =====================

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  temaGelap.value = prefs.getBool('gelap') ?? false;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: temaGelap,
      builder: (context, gelap, _) {
        return MaterialApp(
          title: 'Pencatat Pengeluaran',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(colorSchemeSeed: Colors.teal, useMaterial3: true),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            colorSchemeSeed: Colors.teal,
            useMaterial3: true,
          ),
          themeMode: gelap ? ThemeMode.dark : ThemeMode.light,
          home: const PengeluaranPage(),
        );
      },
    );
  }
}

// ===================== Halaman Utama =====================

class PengeluaranPage extends StatefulWidget {
  const PengeluaranPage({super.key});

  @override
  State<PengeluaranPage> createState() => _PengeluaranPageState();
}

class _PengeluaranPageState extends State<PengeluaranPage> {
  List<Pengeluaran> _data = [];
  int _total = 0;
  bool _loading = true;
  String? _galat;

  @override
  void initState() {
    super.initState();
    _muat();
  }

  Future<void> _muat() async {
    try {
      final data = await DbHelper.semua();
      final total = await DbHelper.total();
      if (!mounted) return;
      setState(() {
        _data = data;
        _total = total;
        _loading = false;
        _galat = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _galat = e.toString();
        _loading = false;
      });
    }
  }

  Future<void> _ubahTema(bool nilai) async {
    temaGelap.value = nilai;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('gelap', nilai);
  }

  Future<void> _buka([Pengeluaran? x]) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => FormPengeluaranPage(pengeluaran: x)),
    );
    if (!mounted) return;
    _muat();
  }

  Future<void> _hapus(Pengeluaran x) async {
    final yakin = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus pengeluaran ini?'),
        content: Text('"${x.nama}" (${rupiah(x.jumlah)}) akan dihapus.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (yakin != true) return;
    await DbHelper.hapus(x.id!);
    if (!mounted) return;
    _muat();
  }

  Widget _isi() {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_galat != null) return Center(child: Text('Galat: $_galat'));
    if (_data.isEmpty) {
      return const Center(child: Text('Belum ada pengeluaran'));
    }
    return ListView.builder(
      itemCount: _data.length,
      itemBuilder: (context, i) {
        final x = _data[i];
        return ListTile(
          leading: CircleAvatar(child: Text(x.kategori[0])),
          title: Text(x.nama),
          subtitle: Text('${x.kategori} • ${x.tanggal}'),
          onTap: () => _buka(x),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                rupiah(x.jumlah),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => _hapus(x),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final gelap = temaGelap.value;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pencatat Pengeluaran'),
        actions: [
          IconButton(
            tooltip: gelap ? 'Mode terang' : 'Mode gelap',
            icon: Icon(gelap ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => _ubahTema(!gelap),
          ),
        ],
      ),
      body: Column(
        children: [
          // Kartu total pengeluaran
          Card(
            margin: const EdgeInsets.all(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total Pengeluaran',
                      style: TextStyle(fontSize: 16)),
                  Text(
                    rupiah(_total),
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          Expanded(child: _isi()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _buka(),
        child: const Icon(Icons.add),
      ),
    );
  }
}

// ===================== Form Tambah & Ubah =====================

class FormPengeluaranPage extends StatefulWidget {
  final Pengeluaran? pengeluaran;
  const FormPengeluaranPage({super.key, this.pengeluaran});

  @override
  State<FormPengeluaranPage> createState() => _FormPengeluaranPageState();
}

class _FormPengeluaranPageState extends State<FormPengeluaranPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nama;
  late final TextEditingController _jumlah;
  String? _kategori;
  late DateTime _tanggal;

  @override
  void initState() {
    super.initState();
    final x = widget.pengeluaran;
    _nama = TextEditingController(text: x?.nama ?? '');
    _jumlah = TextEditingController(text: x?.jumlah.toString() ?? '');
    _kategori = x?.kategori;
    _tanggal = x != null
        ? (DateTime.tryParse(x.tanggal) ?? DateTime.now())
        : DateTime.now();
  }

  @override
  void dispose() {
    _nama.dispose();
    _jumlah.dispose();
    super.dispose();
  }

  Future<void> _pilihTanggal() async {
    final hasil = await showDatePicker(
      context: context,
      initialDate: _tanggal,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (hasil != null) setState(() => _tanggal = hasil);
  }

  Future<void> _simpan() async {
    if (!_formKey.currentState!.validate()) return;
    final x = Pengeluaran(
      id: widget.pengeluaran?.id,
      nama: _nama.text.trim(),
      jumlah: int.parse(_jumlah.text.trim()),
      kategori: _kategori!,
      tanggal: formatTanggal(_tanggal),
    );
    if (widget.pengeluaran == null) {
      await DbHelper.tambah(x);
    } else {
      await DbHelper.ubah(x);
    }
    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final baru = widget.pengeluaran == null;
    return Scaffold(
      appBar: AppBar(
        title: Text(baru ? 'Pengeluaran Baru' : 'Ubah Pengeluaran'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nama,
              decoration: const InputDecoration(
                labelText: 'Nama pengeluaran',
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Nama wajib diisi' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _jumlah,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Jumlah (Rp)',
                border: OutlineInputBorder(),
              ),
              validator: (v) {
                final n = int.tryParse((v ?? '').trim());
                if (n == null) return 'Jumlah harus berupa angka';
                if (n <= 0) return 'Jumlah harus lebih dari 0';
                return null;
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _kategori,
              decoration: const InputDecoration(
                labelText: 'Kategori',
                border: OutlineInputBorder(),
              ),
              items: kKategori
                  .map((k) => DropdownMenuItem(value: k, child: Text(k)))
                  .toList(),
              onChanged: (v) => setState(() => _kategori = v),
              validator: (v) => v == null ? 'Kategori wajib dipilih' : null,
            ),
            const SizedBox(height: 12),
            InkWell(
              onTap: _pilihTanggal,
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Tanggal',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                child: Text(formatTanggal(_tanggal)),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _simpan, child: const Text('Simpan')),
          ],
        ),
      ),
    );
  }
}