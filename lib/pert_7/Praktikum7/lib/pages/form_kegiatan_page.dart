import 'package:flutter/material.dart';
import '../data/db_helper.dart';
import '../models/kegiatan.dart';
import '../utils/format.dart';

class FormKegiatanPage extends StatefulWidget {
  const FormKegiatanPage({Key? key}) : super(key: key);

  @override
  State<FormKegiatanPage> createState() => _FormKegiatanPageState();
}

class _FormKegiatanPageState extends State<FormKegiatanPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _judulController;
  late TextEditingController _nominalController;

  String _tanggal = FormatUtil.hariIni();
  String _tipe = 'tanpa';
  String _kategori = 'Makan';
  int? _editId;
  bool _selesai = false;

  @override
  void initState() {
    super.initState();
    _judulController = TextEditingController();
    _nominalController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      if (args['tanggal'] != null) _tanggal = args['tanggal'];
      if (args['kegiatan'] != null) {
        final k = args['kegiatan'] as Kegiatan;
        _editId = k.id;
        _judulController.text = k.judul;
        _tanggal = k.tanggal;
        _tipe = k.tipe;
        _nominalController.text = k.nominal > 0 ? k.nominal.toString() : '';
        _kategori = k.kategori != '-' ? k.kategori : 'Makan';
        _selesai = k.selesai;
      }
    }
  }

  @override
  void dispose() {
    _judulController.dispose();
    _nominalController.dispose();
    super.dispose();
  }

  void _simpan() async {
    if (!_formKey.currentState!.validate()) return;
    int nominalVal = 0;
    if (_tipe != 'tanpa') {
      nominalVal = int.tryParse(_nominalController.text.trim()) ?? 0;
      if (nominalVal <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Nominal harus > 0')));
        return;
      }
    }

    final kegiatan = Kegiatan(
      id: _editId,
      judul: _judulController.text.trim(),
      tanggal: _tanggal,
      selesai: _selesai,
      tipe: _tipe,
      nominal: nominalVal,
      kategori: _tipe == 'pengeluaran' ? _kategori : '-',
    );

    if (_editId == null) {
      await DbHelper.tambah(kegiatan);
    } else {
      await DbHelper.ubah(kegiatan);
    }

    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_editId == null ? 'Tambah Kegiatan' : 'Ubah Kegiatan')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _judulController,
              decoration: const InputDecoration(labelText: 'Nama Kegiatan', border: OutlineInputBorder()),
              validator: (val) => val == null || val.trim().isEmpty ? 'Wajib diisi' : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _tipe,
              decoration: const InputDecoration(labelText: 'Jenis Keuangan', border: OutlineInputBorder()),
              items: const [
                DropdownMenuItem(value: 'tanpa', child: Text('Tidak Melibatkan Uang')),
                DropdownMenuItem(value: 'pemasukan', child: Text('Pemasukan')),
                DropdownMenuItem(value: 'pengeluaran', child: Text('Pengeluaran')),
              ],
              onChanged: (val) => setState(() => _tipe = val!),
            ),
            if (_tipe != 'tanpa') ...[
              const SizedBox(height: 16),
              TextFormField(
                controller: _nominalController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Nominal (Rp)', border: OutlineInputBorder()),
                validator: (val) => val == null || int.tryParse(val) == null || int.parse(val) <= 0 ? 'Nominal harus angka > 0' : null,
              ),
            ],
            if (_tipe == 'pengeluaran') ...[
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _kategori,
                decoration: const InputDecoration(labelText: 'Kategori', border: OutlineInputBorder()),
                items: ['Makan', 'Transport', 'Belajar', 'Hiburan', 'Lainnya']
                    .map((kat) => DropdownMenuItem(value: kat, child: Text(kat)))
                    .toList(),
                onChanged: (val) => setState(() => _kategori = val!),
              ),
            ],
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _simpan,
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}
