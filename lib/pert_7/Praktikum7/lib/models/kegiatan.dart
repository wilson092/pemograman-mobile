class Kegiatan {
  final int? id;
  final String judul;
  final String tanggal; // yyyy-MM-dd
  final bool selesai;
  final String tipe; // 'tanpa', 'pemasukan', 'pengeluaran'
  final int nominal;
  final String kategori; // 'Makan', 'Transport', 'Belajar', 'Hiburan', 'Lainnya', '-'

  Kegiatan({
    this.id,
    required this.judul,
    required this.tanggal,
    required this.selesai,
    required this.tipe,
    required this.nominal,
    required this.kategori,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'judul': judul,
      'tanggal': tanggal,
      'selesai': selesai ? 1 : 0,
      'tipe': tipe,
      'nominal': nominal,
      'kategori': kategori,
    };
  }

  factory Kegiatan.fromMap(Map<String, dynamic> map) {
    return Kegiatan(
      id: map['id'] as int?,
      judul: map['judul'] as String,
      tanggal: map['tanggal'] as String,
      selesai: (map['selesai'] as int) == 1,
      tipe: map['tipe'] as String,
      nominal: map['nominal'] as int,
      kategori: map['kategori'] as String,
    );
  }

  Kegiatan copyWith({
    int? id,
    String? judul,
    String? tanggal,
    bool? selesai,
    String? tipe,
    int? nominal,
    String? kategori,
  }) {
    return Kegiatan(
      id: id ?? this.id,
      judul: judul ?? this.judul,
      tanggal: tanggal ?? this.tanggal,
      selesai: selesai ?? this.selesai,
      tipe: tipe ?? this.tipe,
      nominal: nominal ?? this.nominal,
      kategori: kategori ?? this.kategori,
    );
  }
}

class RingkasanHari {
  final int totalKegiatan;
  final int selesaiKegiatan;
  final int totalPemasukan;
  final int totalPengeluaran;

  RingkasanHari({
    required this.totalKegiatan,
    required this.selesaiKegiatan,
    required this.totalPemasukan,
    required this.totalPengeluaran,
  });

  int get tabungan => totalPemasukan - totalPengeluaran;
}
