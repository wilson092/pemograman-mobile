// Checkpoint B
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

class Catatan {
  final int? id;
  final String judul;
  final String isi;

  const Catatan({this.id, required this.judul, required this.isi});

  Map<String, Object?> toMap() => {'id': id, 'judul': judul, 'isi': isi};

  factory Catatan.fromMap(Map<String, Object?> m) => Catatan(
        id: m['id'] as int,
        judul: m['judul'] as String,
        isi: m['isi'] as String,
      );
}

class DbHelper {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    final path = p.join(await getDatabasesPath(), 'catatan.db');
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE catatan('
          'id INTEGER PRIMARY KEY AUTOINCREMENT, '
          'judul TEXT NOT NULL, '
          'isi TEXT NOT NULL)',
        );
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

  static Future<int> ubah(Catatan c) async {
    final db = await database;
    return db.update('catatan', c.toMap(), where: 'id = ?', whereArgs: [c.id]);
  }

  static Future<int> hapus(int id) async {
    final db = await database;
    return db.delete('catatan', where: 'id = ?', whereArgs: [id]);
  }
}

// main() sementara, hanya agar kode bisa dicek dan dijalankan.
// Akan diganti di Bagian C.
void main() => runApp(const MaterialApp(
      home: Scaffold(body: Center(child: Text('Bagian B: DbHelper siap'))),
    ));