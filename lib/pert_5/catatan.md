## Yang Dipelajari

### 1. Penyimpanan Lokal (Persistence)
* **Persistence** adalah kemampuan aplikasi menyimpan data di penyimpanan perangkat agar tidak hilang saat aplikasi ditutup (data di memori seperti variabel dan *State* akan hilang).
* Ada tiga pilihan penyimpanan: **key-value** (`shared_preferences`) untuk pengaturan kecil, **database SQLite** (`sqflite`, `path`) untuk data terstruktur dan banyak, serta **berkas** (`path_provider`, `dart:io`) untuk dokumen, gambar, dan ekspor/impor data.
* Memilih jenis penyimpanan yang tepat sesuai kebutuhan data.

### 2. SharedPreferences (Key-Value)
* **SharedPreferences** menyimpan data sederhana berpasangan kunci-nilai, seperti nama, mode gelap, status login, dan hitungan angka terakhir.
* **SharedPreferences.getInstance()** mengembalikan `Future` sehingga harus dipanggil dengan `await`.
* **setString()**, **setBool()**, **setInt()** digunakan untuk menyimpan nilai, sedangkan **getString()**, **getBool()**, **getInt()** untuk membacanya.
* Nilai bawaan ditentukan dengan operator `??` (contoh: `prefs.getString('nama') ?? ''`) karena pembacaan awal bisa bernilai `null`.

### 3. SQLite dengan sqflite
* **SQLite** adalah database lokal berbasis tabel yang cocok untuk data terstruktur dan banyak (catatan, transaksi, daftar produk).
* **openDatabase()** membuka (atau membuat) berkas database, dengan lokasi dari **getDatabasesPath()** dan **path.join()**.
* **onCreate** dijalankan sekali saat database pertama kali dibuat, berisi perintah `CREATE TABLE`.
* **onUpgrade** dijalankan saat `version` dinaikkan, dipakai untuk migrasi skema (contoh: `ALTER TABLE ... ADD COLUMN`).
* **AUTOINCREMENT** membuat `id` terisi otomatis oleh SQLite, sehingga bernilai `null` saat objek baru dibuat.

### 4. Operasi CRUD
* **CRUD** terdiri dari Create, Read, Update, Delete, dan masing-masing memiliki padanan perintah SQL.
* **Create** memakai `db.insert()` (SQL `INSERT`), **Read** memakai `db.query()` (SQL `SELECT`), **Update** memakai `db.update()` (SQL `UPDATE`), dan **Delete** memakai `db.delete()` (SQL `DELETE`).
* **Model dan DbHelper**: class model (`Catatan`) dilengkapi `toMap()` dan `fromMap()` untuk mengonversi objek Dart dari dan ke baris tabel, sedangkan `DbHelper` memisahkan akses data dari UI.

### 5. Keamanan Query (SQL Injection)
* Query tidak boleh disusun dengan menyambung teks input pengguna secara langsung.
* Gunakan **placeholder `?`** bersama **whereArgs** (contoh: `where: 'id = ?', whereArgs: [id]`) agar aman dari SQL injection.
* Pencarian memakai `LIKE` tetap aman dengan `where: 'judul LIKE ?', whereArgs: ['%$kata%']`.

### 6. Menghubungkan Database dengan UI
* **FutureBuilder** menampilkan data dari database dalam tiga keadaan: *loading*, *error*, dan *data* (kosong atau berisi).
* Setelah tambah, ubah, atau hapus, daftar perlu **dimuat ulang** dengan membuat `Future` baru lewat `setState` (fungsi `_muat()`).
* **Satu form untuk dua keperluan**: bila parameter `catatan` bernilai `null` berarti tambah, bila terisi berarti ubah.
* **Validasi form** memakai `Form`, `GlobalKey<FormState>`, dan `validator` pada `TextFormField`.

### 7. Praktik Aman Async di Flutter
* **`if (!mounted) return;`** diperiksa setelah setiap `await` sebelum memakai `context` atau `setState`, untuk menghindari peringatan `use_build_context_synchronously`.
* **dispose()** dipakai untuk melepas `TextEditingController` agar tidak terjadi kebocoran memori.
* **Hot reload tidak memuat plugin baru**, sehingga setelah menambah paket native aplikasi harus di-Stop total lalu dijalankan ulang untuk menghindari `MissingPluginException`.

---

## Pertanyaan Refleksi

### 1. Mengapa shared_preferences kurang cocok untuk menyimpan ratusan catatan? Apa pilihan yang lebih baik?
`shared_preferences` dirancang untuk data kecil berpasangan kunci-nilai, bukan data banyak dan terstruktur. Tidak ada kemampuan query (cari, filter, urutkan), tidak ada relasi antartabel, dan seluruh data cenderung dimuat sekaligus sehingga lambat dan boros memori bila jumlahnya ratusan. Pilihan yang lebih baik adalah **database SQLite (`sqflite`)** karena mendukung tabel, query SQL (`WHERE`, `ORDER BY`, `LIKE`), dan pengelolaan data banyak secara efisien.

### 2. Mengapa query memakai placeholder ? dan whereArgs, bukan menyambung teks langsung?
Untuk mencegah **SQL injection**. Bila teks dari pengguna disambung langsung ke query, pengguna dapat menyisipkan perintah SQL berbahaya (misalnya mengubah kondisi `WHERE` atau menghapus data). Dengan placeholder `?` dan `whereArgs`, nilai diperlakukan sebagai **data murni**, bukan bagian dari perintah SQL, sehingga query tetap aman.

### 3. Mengapa setelah kembali dari halaman form, daftar perlu dimuat ulang? Bagaimana caranya pada kode ini?
Karena halaman daftar tidak otomatis mengetahui bahwa data di database sudah berubah. `Future` lama pada `FutureBuilder` masih menyimpan hasil sebelumnya, sehingga data baru tidak muncul. Pada kode ini, fungsi `_buka()` memakai `await Navigator.push(...)` untuk menunggu halaman form ditutup, lalu memanggil `_muat()` yang membuat `Future` baru (`_future = DbHelper.semua()`) di dalam `setState`, sehingga `FutureBuilder` membangun ulang tampilan dengan data terbaru.

### 4. Apa fungsi onCreate dan onUpgrade, dan kapan masing-masing dijalankan?
* **onCreate** berfungsi membuat struktur database (tabel) dan dijalankan **hanya sekali**, yaitu saat berkas database belum ada dan dibuat pertama kali.
* **onUpgrade** berfungsi memigrasi skema database lama ke versi baru tanpa menghilangkan data, dan dijalankan saat database sudah ada dengan `version` lama **lebih kecil** dari `version` yang diberikan pada `openDatabase()`. Bila `version` tidak dinaikkan, keduanya tidak dijalankan sehingga perubahan skema tidak diterapkan (muncul error seperti `no such column`).