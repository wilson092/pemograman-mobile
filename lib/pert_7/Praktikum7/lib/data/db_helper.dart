import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/kegiatan.dart';

final ValueNotifier<int> versiData = ValueNotifier<int>(0);

class DbHelper {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  static Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'tabungku.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE kegiatan(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            judul TEXT NOT NULL,
            tanggal TEXT NOT NULL,
            selesai INTEGER NOT NULL,
            tipe TEXT NOT NULL,
            nominal INTEGER NOT NULL,
            kategori TEXT NOT NULL
          )
        ''');
      },
    );
  }

  static void _notifikasiPerubahan() {
    versiData.value++;
  }

  static Future<int> tambah(Kegiatan kegiatan) async {
    final db = await database;
    final id = await db.insert('kegiatan', kegiatan.toMap());
    _notifikasiPerubahan();
    return id;
  }

  static Future<List<Kegiatan>> ambilBerdasarkanTanggal(String tanggal) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'kegiatan',
      where: 'tanggal = ?',
      whereArgs: [tanggal],
      orderBy: 'id DESC',
    );
    return List.generate(maps.length, (i) => Kegiatan.fromMap(maps[i]));
  }

  static Future<List<Kegiatan>> ambilSemua() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('kegiatan', orderBy: 'tanggal DESC, id DESC');
    return List.generate(maps.length, (i) => Kegiatan.fromMap(maps[i]));
  }

  static Future<int> ubah(Kegiatan kegiatan) async {
    final db = await database;
    final count = await db.update(
      'kegiatan',
      kegiatan.toMap(),
      where: 'id = ?',
      whereArgs: [kegiatan.id],
    );
    _notifikasiPerubahan();
    return count;
  }

  static Future<int> hapus(int id) async {
    final db = await database;
    final count = await db.delete(
      'kegiatan',
      where: 'id = ?',
      whereArgs: [id],
    );
    _notifikasiPerubahan();
    return count;
  }

  static Future<RingkasanHari> ringkasanHari(String tanggal) async {
    final db = await database;
    
    int totalKegiatan = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM kegiatan WHERE tanggal = ?', [tanggal])) ?? 0;
    int selesaiKegiatan = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM kegiatan WHERE tanggal = ? AND selesai = 1', [tanggal])) ?? 0;

    int totalPemasukan = Sqflite.firstIntValue(await db.rawQuery('SELECT COALESCE(SUM(nominal), 0) FROM kegiatan WHERE tanggal = ? AND tipe = "pemasukan"', [tanggal])) ?? 0;
    int totalPengeluaran = Sqflite.firstIntValue(await db.rawQuery('SELECT COALESCE(SUM(nominal), 0) FROM kegiatan WHERE tanggal = ? AND tipe = "pengeluaran"', [tanggal])) ?? 0;

    return RingkasanHari(
      totalKegiatan: totalKegiatan,
      selesaiKegiatan: selesaiKegiatan,
      totalPemasukan: totalPemasukan,
      totalPengeluaran: totalPengeluaran,
    );
  }

  static Future<Map<String, int>> pengeluaranPerKategori(String tanggal) async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db.rawQuery(
      'SELECT kategori, SUM(nominal) as total FROM kegiatan WHERE tanggal = ? AND tipe = "pengeluaran" GROUP BY kategori',
      [tanggal],
    );
    Map<String, int> data = {};
    for (var row in results) {
      data[row['kategori'] as String] = row['total'] as int;
    }
    return data;
  }
}
