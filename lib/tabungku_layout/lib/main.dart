import 'package:flutter/material.dart';

// Titik masuk aplikasi
void main() {
  runApp(const TabungKuApp());
}

// Widget root aplikasi
class TabungKuApp extends StatelessWidget {
  const TabungKuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TabungKu',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const RingkasanPage(),
    );
  }
}

// Model sederhana untuk data transaksi (data statis / hard-coded)
class Transaksi {
  final String judul;
  final String tanggal;
  final int nominal;
  final bool masuk; // true = menabung, false = penarikan

  const Transaksi(this.judul, this.tanggal, this.nominal, this.masuk);
}

// Data transaksi statis
const List<Transaksi> daftarTransaksi = [
  Transaksi('Setoran Gaji Bulanan', '01 Nov 2026', 1500000, true),
  Transaksi('Tarik untuk Beli Buku', '05 Nov 2026', 250000, false),
  Transaksi('Setoran Uang Saku', '08 Nov 2026', 500000, true),
  Transaksi('Setoran Bonus Proyek', '10 Nov 2026', 750000, true),
];

// Fungsi bantu: format angka ke Rupiah (tanpa paket pihak ketiga)
String formatRupiah(int angka) {
  final teks = angka.toString();
  final buffer = StringBuffer();
  for (int i = 0; i < teks.length; i++) {
    if (i > 0 && (teks.length - i) % 3 == 0) buffer.write('.');
    buffer.write(teks[i]);
  }
  return 'Rp $buffer';
}

// Halaman utama: Ringkasan Tabungan
class RingkasanPage extends StatelessWidget {
  const RingkasanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar dengan judul sesuai ketentuan
      appBar: AppBar(
        title: const Text('Ringkasan Tabungan'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      // SingleChildScrollView mencegah overflow pada layar kecil/landscape
      body: SingleChildScrollView(
        // Center + ConstrainedBox agar konten tidak melebar berlebihan di tablet
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const KartuTabungan(),
                  const SizedBox(height: 20),
                  const BarisKategori(),
                  const SizedBox(height: 24),
                  const Text(
                    'Transaksi Terakhir',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  // Daftar transaksi dibuat dari data statis
                  for (final t in daftarTransaksi) ItemTransaksi(transaksi: t),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Bagian 1: Kartu informasi tabungan (Card + Column + Row)
class KartuTabungan extends StatelessWidget {
  const KartuTabungan({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Baris nama tabungan + ikon
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Tabungan Laptop Baru',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Icon(Icons.savings, color: Colors.teal, size: 28),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Saldo Saat Ini', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 4),
            Text(
              formatRupiah(3500000),
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 16),
            // Baris target dan persentase
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Target',
                        style: TextStyle(color: Colors.grey)),
                    Text(
                      formatRupiah(10000000),
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: const [
                    Text('Tercapai', style: TextStyle(color: Colors.grey)),
                    Text(
                      '35%',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Bagian 2: Baris tiga tombol kategori (Row)
class BarisKategori extends StatelessWidget {
  const BarisKategori({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: const [
        TombolKategori(ikon: Icons.add_circle, label: 'Menabung'),
        TombolKategori(ikon: Icons.remove_circle, label: 'Tarik'),
        TombolKategori(ikon: Icons.history, label: 'Riwayat'),
      ],
    );
  }
}

// Satu tombol kategori: ikon di dalam Container bulat + label di bawahnya
class TombolKategori extends StatelessWidget {
  final IconData ikon;
  final String label;

  const TombolKategori({super.key, required this.ikon, required this.label});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {}, // Belum ada aksi, fokus tugas ini hanya layout
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60,
              height: 60,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.teal.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(ikon, color: Colors.teal, size: 30),
            ),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}

// Bagian 3: Satu item transaksi (judul, tanggal, nominal)
class ItemTransaksi extends StatelessWidget {
  final Transaksi transaksi;

  const ItemTransaksi({super.key, required this.transaksi});

  @override
  Widget build(BuildContext context) {
    final warna = transaksi.masuk ? Colors.green : Colors.red;
    final tanda = transaksi.masuk ? '+' : '-';

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            transaksi.masuk ? Icons.arrow_downward : Icons.arrow_upward,
            color: warna,
          ),
          const SizedBox(width: 12),
          // Expanded mencegah overflow pada teks judul yang panjang
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaksi.judul,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  transaksi.tanggal,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '$tanda ${formatRupiah(transaksi.nominal)}',
            style: TextStyle(fontWeight: FontWeight.bold, color: warna),
          ),
        ],
      ),
    );
  }
}