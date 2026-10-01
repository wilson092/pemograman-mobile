import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Belanja {
  String nama;
  int jumlah;
  String kategori;
  bool dibeli;

  Belanja(
    this.nama,
    this.jumlah,
    this.kategori, {
    this.dibeli = false,
  });
}

class BelanjaModel extends ChangeNotifier {
  final List<Belanja> _items = [];

  List<Belanja> get items => List.unmodifiable(_items);

  int get jumlahBelumDibeli =>
      _items.where((item) => !item.dibeli).length;

  void tambah(String nama, int jumlah, String kategori) {
    _items.add(
      Belanja(
        nama,
        jumlah,
        kategori,
      ),
    );

    notifyListeners();
  }

  void toggle(int index) {
    _items[index].dibeli = !_items[index].dibeli;
    notifyListeners();
  }

  void hapus(int index) {
    _items.removeAt(index);
    notifyListeners();
  }
}

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => BelanjaModel(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daftar Belanja',
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
      ),
      home: const BelanjaPage(),
    );
  }
}

class BelanjaPage extends StatelessWidget {
  const BelanjaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<BelanjaModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Daftar Belanja (${model.jumlahBelumDibeli})',
        ),
      ),

      body: model.items.isEmpty
          ? const Center(
              child: Text('Belum ada barang'),
            )
          : ListView.builder(
              itemCount: model.items.length,
              itemBuilder: (context, index) {
                final item = model.items[index];

                return ListTile(
                  leading: Checkbox(
                    value: item.dibeli,
                    onChanged: (_) {
                      context
                          .read<BelanjaModel>()
                          .toggle(index);
                    },
                  ),

                  title: Text(
                    item.nama,
                    style: TextStyle(
                      decoration: item.dibeli
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),

                  subtitle: Text(
                    'Jumlah: ${item.jumlah} • '
                    'Kategori: ${item.kategori}',
                  ),

                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      context
                          .read<BelanjaModel>()
                          .hapus(index);
                    },
                  ),
                );
              },
            ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const TambahBelanjaPage(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class TambahBelanjaPage extends StatefulWidget {
  const TambahBelanjaPage({super.key});

  @override
  State<TambahBelanjaPage> createState() =>
      _TambahBelanjaPageState();
}

class _TambahBelanjaPageState
    extends State<TambahBelanjaPage> {
  final _formKey = GlobalKey<FormState>();

  final _namaController = TextEditingController();
  final _jumlahController = TextEditingController();

  String? _kategori;

  @override
  void dispose() {
    _namaController.dispose();
    _jumlahController.dispose();
    super.dispose();
  }

  void _simpan() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final nama = _namaController.text.trim();
    final jumlah = int.parse(_jumlahController.text);
    final kategori = _kategori!;

    context.read<BelanjaModel>().tambah(
          nama,
          jumlah,
          kategori,
        );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Belanja'),
      ),

      body: Form(
        key: _formKey,

        child: ListView(
          padding: const EdgeInsets.all(16),

          children: [
            TextFormField(
              controller: _namaController,

              decoration: const InputDecoration(
                labelText: 'Nama barang',
                border: OutlineInputBorder(),
              ),

              validator: (value) {
                if (value == null ||
                    value.trim().isEmpty) {
                  return 'Nama barang wajib diisi';
                }

                return null;
              },
            ),

            const SizedBox(height: 12),

            TextFormField(
              controller: _jumlahController,

              keyboardType: TextInputType.number,

              decoration: const InputDecoration(
                labelText: 'Jumlah',
                border: OutlineInputBorder(),
              ),

              validator: (value) {
                if (value == null ||
                    value.trim().isEmpty) {
                  return 'Jumlah wajib diisi';
                }

                final jumlah = int.tryParse(value);

                if (jumlah == null || jumlah <= 0) {
                  return 'Jumlah harus lebih dari 0';
                }

                return null;
              },
            ),

            const SizedBox(height: 12),

            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Kategori',
                border: OutlineInputBorder(),
              ),

              value: _kategori,

              items: const [
                DropdownMenuItem(
                  value: 'Makanan',
                  child: Text('Makanan'),
                ),
                DropdownMenuItem(
                  value: 'Minuman',
                  child: Text('Minuman'),
                ),
                DropdownMenuItem(
                  value: 'Kebutuhan Rumah',
                  child: Text('Kebutuhan Rumah'),
                ),
                DropdownMenuItem(
                  value: 'Lainnya',
                  child: Text('Lainnya'),
                ),
              ],

              onChanged: (value) {
                setState(() {
                  _kategori = value;
                });
              },

              validator: (value) {
                if (value == null) {
                  return 'Pilih kategori';
                }

                return null;
              },
            ),

            const SizedBox(height: 20),

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