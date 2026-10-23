# Catatan Pertemuan 7: Mini Proyek Terpadu — TabungKu

## Yang Dipelajari
1. **Integrasi Komprehensif (Pertemuan 1–6):** Menggabungkan seluruh konsep widget, form & validasi, SQLite (`sqflite`), state management (`Provider`), SharedPreferences, NavigationBar, Named Routes, hingga animasi dan tema dinamis ke dalam satu aplikasi utuh.
2. **Query Agregasi SQLite:** Menggunakan fungsi SQL seperti `SUM`, `COUNT`, dan `GROUP BY` (serta `COALESCE`) langsung di database untuk menghasilkan laporan keuangan harian secara efisien.
3. **Pola Observer Sederhana (`ValueNotifier`):** Menggunakan `ValueNotifier<int> versiData` yang di-listen oleh halaman-halaman berbeda agar data antar tab selalu sinkron secara *real-time* tanpa perlu restart.
4. **Manajemen State & Pengaturan:** Menyimpan preferensi pengguna (Dark Mode, warna tema *seed color*, target tabungan harian) menggunakan `SharedPreferences` dan `ChangeNotifierProvider`.

---

## Pertanyaan Refleksi
1. **Mengapa tanggal disimpan sebagai teks `yyyy-MM-dd`?**
   Format ini leksikografis, sehingga sangat mudah diurutkan dan dibandingkan langsung oleh query SQLite (`WHERE tanggal = ?`).
2. **Mengapa laporan dihitung dengan query `SUM` di database, bukan dengan menjumlahkan di Dart?**
   Lebih efisien karena database memproses komputasi secara langsung pada tingkat penyimpanan, mengurangi beban memori Dart saat data dalam jumlah besar.
3. **Bagaimana tiga tab dapat menampilkan data yang selalu sinkron?**
   Melalui `ValueNotifier` (`versiData`) yang memicu pembaharuan `Future` (`_muat()`) pada setiap halaman ketika operasi CRUD SQLite dilakukan.
