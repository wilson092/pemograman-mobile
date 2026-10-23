import 'package:flutter/material.dart';
import '../models/kegiatan.dart';
import '../utils/format.dart';

class RingkasanCard extends StatelessWidget {
  final RingkasanHari ringkasan;
  final int targetTabungan;

  const RingkasanCard({
    Key? key,
    required this.ringkasan,
    required this.targetTabungan,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tabungan = ringkasan.tabungan;
    final tercapai = tabungan >= targetTabungan;
    final progress = targetTabungan > 0 ? (tabungan / targetTabungan).clamp(0.0, 1.0) : 1.0;

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Ringkasan Hari Ini', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${ringkasan.selesaiKegiatan}/${ringkasan.totalKegiatan} Selesai',
                    style: TextStyle(color: theme.colorScheme.onPrimaryContainer, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              children: [
                Expanded(child: _infoKolom(context, 'Pemasukan', FormatUtil.rupiah(ringkasan.totalPemasukan), Colors.green, Icons.arrow_downward)),
                Container(width: 1, height: 40, color: theme.dividerColor),
                Expanded(child: _infoKolom(context, 'Pengeluaran', FormatUtil.rupiah(ringkasan.totalPengeluaran), Colors.red, Icons.arrow_upward)),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: tabungan < 0 ? Colors.red.withOpacity(0.1) : theme.colorScheme.surfaceVariant.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: tabungan < 0 ? Colors.red : Colors.transparent),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Tabungan Hari Ini:'),
                      Text(
                        FormatUtil.rupiah(tabungan),
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: tabungan < 0 ? Colors.red : (tercapai ? Colors.green : theme.colorScheme.primary),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Target: ${FormatUtil.rupiah(targetTabungan)}', style: theme.textTheme.bodySmall),
                      Text(
                        tabungan < 0 ? 'Peringatan: Tabungan Negatif!' : (tercapai ? 'Target Tercapai 🎉' : 'Belum Mencapai Target'),
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: tabungan < 0 ? Colors.red : (tercapai ? Colors.green : Colors.orange),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: tabungan < 0 ? 0.0 : progress.toDouble(),
                      backgroundColor: theme.colorScheme.surface,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        tabungan < 0 ? Colors.red : (tercapai ? Colors.green : theme.colorScheme.primary),
                      ),
                      minHeight: 8,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoKolom(BuildContext context, String label, String nilai, Color warna, IconData ikon) {
    return Row(
      children: [
        CircleAvatar(backgroundColor: warna.withOpacity(0.15), radius: 18, child: Icon(ikon, color: warna, size: 18)),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 2),
            Text(nilai, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, color: warna)),
          ],
        ),
      ],
    );
  }
}
