import 'package:flutter/material.dart';
import '../data/db_helper.dart';
import '../utils/format.dart';

class LaporanPage extends StatefulWidget {
  const LaporanPage({Key? key}) : super(key: key);

  @override
  State<LaporanPage> createState() => _LaporanPageState();
}

class _LaporanPageState extends State<LaporanPage> {
  String _tgl = FormatUtil.hariIni();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Laporan TabungKu')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Tanggal: ${_tgl}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ElevatedButton(
                onPressed: () async {
                  final p = await showDatePicker(
                    context: context,
                    initialDate: DateTime.parse(_tgl),
                    firstDate: DateTime(2023),
                    lastDate: DateTime(2030),
                  );
                  if (p != null) {
                    setState(() {
                      _tgl = p.toIso8601String().substring(0, 10);
                    });
                  }
                },
                child: const Text('Pilih Tanggal'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          FutureBuilder(
            future: DbHelper.ringkasanHari(_tgl),
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              final r = snap.data;
              if (r == null) return const Text('Tidak ada data.');
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Ringkasan Tanggal ${_tgl}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const Divider(),
                      Text('Total Kegiatan: ${r.selesaiKegiatan}/${r.totalKegiatan} selesai'),
                      Text('Total Pemasukan: Rp ${r.totalPemasukan}', style: const TextStyle(color: Colors.green)),
                      Text('Total Pengeluaran: Rp ${r.totalPengeluaran}', style: const TextStyle(color: Colors.red)),
                      Text('Tabungan: Rp ${r.tabungan}', style: TextStyle(fontWeight: FontWeight.bold, color: r.tabungan < 0 ? Colors.red : Colors.blue)),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          const Text('Pengeluaran per Kategori:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          FutureBuilder(
            future: DbHelper.pengeluaranPerKategori(_tgl),
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              final map = snap.data ?? {};
              if (map.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('Tidak ada pengeluaran ber-kategori pada tanggal ini.'),
                );
              }
              return ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: map.entries.map((e) => ListTile(
                  title: Text(e.key),
                  trailing: Text('Rp ${e.value}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                )).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
