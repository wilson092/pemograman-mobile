import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/db_helper.dart';
import '../models/kegiatan.dart';
import '../state/pengaturan.dart';
import '../utils/format.dart';
import '../widgets/ringkasan_card.dart';

class BerandaPage extends StatefulWidget {
  const BerandaPage({Key? key}) : super(key: key);

  @override
  State<BerandaPage> createState() => _BerandaPageState();
}

class _BerandaPageState extends State<BerandaPage> {
  late String _tgl;
  late Future<List<Kegiatan>> _fKegiatan;
  late Future<RingkasanHari> _fRingkasan;

  @override
  void initState() {
    super.initState();
    _tgl = FormatUtil.hariIni();
    _muat();
    versiData.addListener(_listener);
  }

  @override
  void dispose() {
    versiData.removeListener(_listener);
    super.dispose();
  }

  void _listener() {
    if (mounted) _muat();
  }

  void _muat() {
    setState(() {
      _fKegiatan = DbHelper.ambilBerdasarkanTanggal(_tgl);
      _fRingkasan = DbHelper.ringkasanHari(_tgl);
    });
  }

  @override
  Widget build(BuildContext context) {
    final pengaturan = context.watch<PengaturanProvider>();
    return Scaffold(
      appBar: AppBar(
        title: Text('TabungKu - ${_tgl}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
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
                  _muat();
                });
              }
            },
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          FutureBuilder<RingkasanHari>(
            future: _fRingkasan,
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              return RingkasanCard(
                ringkasan: snap.data ?? RingkasanHari(totalKegiatan: 0, selesaiKegiatan: 0, totalPemasukan: 0, totalPengeluaran: 0),
                targetTabungan: pengaturan.targetTabungan,
              );
            },
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Daftar Kegiatan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/form', arguments: {'tanggal': _tgl}),
                child: const Text('Tambah'),
              ),
            ],
          ),
          FutureBuilder<List<Kegiatan>>(
            future: _fKegiatan,
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              final list = snap.data ?? [];
              if (list.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Center(child: Text('Belum ada kegiatan.')),
                );
              }
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: list.length,
                itemBuilder: (context, i) {
                  final k = list[i];
                  return Card(
                    child: ListTile(
                      leading: Checkbox(
                        value: k.selesai,
                        onChanged: (v) async => await DbHelper.ubah(k.copyWith(selesai: v ?? false)),
                      ),
                      title: Text(k.judul, style: TextStyle(decoration: k.selesai ? TextDecoration.lineThrough : null)),
                      subtitle: Text('${k.tipe} - Rp ${k.nominal}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, size: 18),
                            onPressed: () => Navigator.pushNamed(context, '/form', arguments: {'kegiatan': k}),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, size: 18, color: Colors.red),
                            onPressed: () async => await DbHelper.hapus(k.id!),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/form', arguments: {'tanggal': _tgl}),
        child: const Icon(Icons.add),
      ),
    );
  }
}
