import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/pengaturan.dart';

class PengaturanPage extends StatelessWidget {
  const PengaturanPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pengaturan = context.watch<PengaturanProvider>();
    final targetController = TextEditingController(text: pengaturan.targetTabungan.toString());

    return Scaffold(
      appBar: AppBar(title: const Text('Pengaturan TabungKu')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: const Text('Mode Gelap (Dark Mode)'),
            value: pengaturan.isDarkMode,
            onChanged: (val) => pengaturan.setDarkMode(val),
          ),
          const Divider(),
          ListTile(
            title: const Text('Warna Tema'),
            trailing: DropdownButton<String>(
              value: pengaturan.warnaTema,
              items: ['Indigo', 'Blue', 'Green', 'Teal', 'Purple', 'Orange']
                  .map((color) => DropdownMenuItem(value: color, child: Text(color)))
                  .toList(),
              onChanged: (val) {
                if (val != null) pengaturan.setWarnaTema(val);
              },
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Target Tabungan Harian', style: TextStyle(fontSize: 16)),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Atur Target Tabungan'),
                          content: TextField(
                            controller: targetController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(labelText: 'Nominal Target (Rp)'),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Batal'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                final val = int.tryParse(targetController.text) ?? 20000;
                                pengaturan.setTargetTabungan(val);
                                Navigator.pop(context);
                              },
                              child: const Text('Simpan'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Text('Rp ${pengaturan.targetTabungan}'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
