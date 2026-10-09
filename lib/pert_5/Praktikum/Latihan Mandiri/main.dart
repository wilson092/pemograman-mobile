import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

// ===================== Model & Database =====================

class Catatan {
  final int? id;
  final String judul;
  final String isi;
  final String? dibuat; // Latihan 3

  const Catatan({this.id, required this.judul, required this.isi, this.dibuat});

  Map<String, Object?> toMap() =>
      {'id': id, 'judul': judul, 'isi': isi, 'dibuat': dibuat};

  factory Catatan.fromMap(Map<String, Object?> m) => Catatan(
        id: m['id'] as int,
        judul: m['judul'] as String,
        isi: m['isi'] as String,
        dibuat: m['dibuat'] as String?,
      );
}

class DbHelper {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    final path = p.join(await getDatabasesPath(), 'catatan.db');
    _db = await openDatabase(
      path,
      version: 2, // Latihan 3: dinaikkan dari 1 ke 2
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE catatan('
          'id INTEGER PRIMARY KEY AUTOINCREMENT, '
          'judul TEXT NOT NULL, '
          'isi TEXT NOT NULL, '
          'dibuat TEXT)',
        );
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('ALTER TABLE catatan ADD COLUMN dibuat TEXT');
        }
      },
    );
    return _db!;
  }

  static Future<int> tambah(Catatan c) async {
    final db = await database;
    return db.insert('catatan', c.toMap());
  }

  static Future<List<Catatan>> semua() async {
    final db = await database;
    final rows = await db.query('catatan', orderBy: 'id DESC');
    return rows.map(Catatan.fromMap).toList();
  }

  // Latihan 2 & 4: pencarian + urutan
  static Future<List<Catatan>> cari(String kata,
      {String urutan = 'id DESC'}) async {
    final db = await database;
    final rows = await db.query(
      'catatan',
      where: 'judul LIKE ?',
      whereArgs: ['%$kata%'],
      orderBy: urutan,
    );
    return rows.map(Catatan.fromMap).toList();
  }

  static Future<int> ubah(Catatan c) async {
    final db = await database;
    return db.update('catatan', c.toMap(), where: 'id = ?', whereArgs: [c.id]);
  }

  static Future<int> hapus(int id) async {
    final db = await database;
    return db.delete('catatan', where: 'id = ?', whereArgs: [id]);
  }
}

// ===================== App =====================

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Praktikum 5',
      home: const CatatanPage(),
    );
  }
}

// ===================== Daftar Catatan =====================

class CatatanPage extends StatefulWidget {
  const CatatanPage({super.key});

  @override
  State<CatatanPage> createState() => _CatatanPageState();
}

class _CatatanPageState extends State<CatatanPage> {
  late Future<List<Catatan>> _future;
  final _cariController = TextEditingController();
  bool _terbaru = true; // Latihan 4

  @override
  void initState() {
    super.initState();
    _future = DbHelper.cari('');
    _muatUrutan();
  }

  @override
  void dispose() {
    _cariController.dispose();
    super.dispose();
  }

  void _muat() {
    setState(() {
      _future = DbHelper.cari(
        _cariController.text.trim(),
        urutan: _terbaru ? 'id DESC' : 'id ASC',
      );
    });
  }

  // Latihan 4: baca & simpan urutan di SharedPreferences
  Future<void> _muatUrutan() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    _terbaru = prefs.getBool('terbaru') ?? true;
    _muat();
  }

  Future<void> _ubahUrutan() async {
    final prefs = await SharedPreferences.getInstance();
    _terbaru = !_terbaru;
    await prefs.setBool('terbaru', _terbaru);
    if (!mounted) return;
    _muat();
  }

  Future<void> _buka([Catatan? catatan]) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => FormCatatanPage(catatan: catatan)),
    );
    if (!mounted) return;
    _muat();
  }

  // Latihan 1: konfirmasi hapus
  Future<void> _hapus(Catatan c) async {
    final yakin = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus catatan ini?'),
        content: Text('"${c.judul}" akan dihapus permanen.'),
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
    await DbHelper.hapus(c.id!);
    if (!mounted) return;
    _muat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catatan Saya'),
        actions: [
          IconButton(
            tooltip: _terbaru ? 'Terbaru dulu' : 'Terlama dulu',
            icon: Icon(_terbaru ? Icons.arrow_downward : Icons.arrow_upward),
            onPressed: _ubahUrutan,
          ),
        ],
      ),
      body: Column(
        children: [
          // Latihan 2: kolom pencarian
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _cariController,
              decoration: const InputDecoration(
                labelText: 'Cari judul',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => _muat(),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Catatan>>(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Galat: ${snapshot.error}'));
                }
                final data = snapshot.data!;
                if (data.isEmpty) {
                  return const Center(child: Text('Belum ada catatan'));
                }
                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, i) {
                    final c = data[i];
                    return ListTile(
                      title: Text(c.judul),
                      subtitle: Text(
                        '${c.dibuat ?? '-'}\n${c.isi}',
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      isThreeLine: true,
                      onTap: () => _buka(c),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _hapus(c),
                      ),
                    );
                  },
                );
              },
            ),
          ),
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

class FormCatatanPage extends StatefulWidget {
  final Catatan? catatan;
  const FormCatatanPage({super.key, this.catatan});

  @override
  State<FormCatatanPage> createState() => _FormCatatanPageState();
}

class _FormCatatanPageState extends State<FormCatatanPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _judul;
  late final TextEditingController _isi;

  @override
  void initState() {
    super.initState();
    _judul = TextEditingController(text: widget.catatan?.judul ?? '');
    _isi = TextEditingController(text: widget.catatan?.isi ?? '');
  }

  @override
  void dispose() {
    _judul.dispose();
    _isi.dispose();
    super.dispose();
  }

  Future<void> _simpan() async {
    if (!_formKey.currentState!.validate()) return;
    final c = Catatan(
      id: widget.catatan?.id,
      judul: _judul.text.trim(),
      isi: _isi.text.trim(),
      // Latihan 3: tanggal dibuat (tidak berubah saat edit)
      dibuat:
          widget.catatan?.dibuat ?? DateTime.now().toString().substring(0, 16),
    );
    if (widget.catatan == null) {
      await DbHelper.tambah(c);
    } else {
      await DbHelper.ubah(c);
    }
    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final baru = widget.catatan == null;
    return Scaffold(
      appBar: AppBar(title: Text(baru ? 'Catatan Baru' : 'Ubah Catatan')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _judul,
              decoration: const InputDecoration(
                labelText: 'Judul',
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Judul wajib diisi' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _isi,
              maxLines: 6,
              decoration: const InputDecoration(
                labelText: 'Isi catatan',
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Isi wajib diisi' : null,
            ),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _simpan, child: const Text('Simpan')),
          ],
        ),
      ),
    );
  }
}