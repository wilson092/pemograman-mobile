

## Yang Dipelajari

### 1. Future, Async, dan Await
* **Future** adalah objek di Dart yang mewakili hasil dari operasi asinkron yang akan tersedia nanti (seperti mengambil data dari internet).
* **async** digunakan untuk menandai fungsi bahwa di dalamnya terdapat proses asinkron.
* **await** digunakan untuk menunggu hasil dari `Future` selesai tanpa menghentikan atau membekuku tampilan UI (*non-blocking*).

### 2. REST API dan JSON Parsing
* **REST API** memungkinkan aplikasi mengirim permintaan HTTP (seperti GET) ke URL server dan menerima respons berformat JSON.
* **jsonDecode()** digunakan untuk mengubah string/teks JSON menjadi objek `Map` atau `List` Dart.
* **http.get()** digunakan untuk mengirim permintaan GET dan mengembalikan `Future<Response>`.

### 3. Class Model dan Constructor fromJson
* **Class Model** digunakan untuk mengubah data JSON mentah menjadi objek Dart ber-type safety.
* **fromJson** adalah *factory constructor* yang memetakan nilai dari `Map<String, dynamic>` JSON ke dalam variabel milik class model.

### 4. FutureBuilder
* **FutureBuilder** adalah widget yang membangun UI secara otomatis berdasarkan status terbaru dari sebuah `Future`.
* **snapshot** menyimpan status koneksi (`connectionState`), data hasil (`data`), dan galat jika terjadi error (`error`).
* Memisahkan tampilan ke dalam 3 keadaan: *loading* (saat menunggu), *error* (saat ada masalah), dan *data* (saat sukses).

### 5. Penanganan Galat Jaringan (Error Handling)
* Penggunaan `throw Exception()` untuk melempar galat saat kode status HTTP bukan 200 (seperti 404 atau 500).
* Penggunaan `.timeout()` untuk membatasi durasi tunggu permintaan HTTP agar aplikasi tidak menggantung.
* Menyediakan tombol **Coba lagi** untuk mememicu ulang pembuatan `Future` saat terjadi kesalahan jaringan.

---

## Pertanyaan Refleksi

### 1. Apa yang terjadi bila Future dibuat di dalam build() dan bukan di initState()? Mengapa?
Permintaan data/HTTP akan dipanggil ulang setiap kali widget dibangun ulang (*rebuild*). Hal ini terjadi karena fungsi `build()` dipanggil berulang kali oleh Flutter (misal saat rotasi layar atau pemanggilan `setState`), sehingga pemicuan `Future` di `build()` akan menyebabkan boros kuota dan *infinite loop* permintaan server.

### 2. Apa perbedaan snapshot.hasError dengan memeriksa response.statusCode? Mengapa keduanya diperlukan?
* `response.statusCode` memeriksa respons dari server HTTP (misal kode 200 untuk sukses, 404 jika tidak ditemukan, atau 500 untuk error server).
* `snapshot.hasError` menangkap Exception/galat tingkat aplikasi (seperti tidak ada koneksi internet, *timeout*, atau kesalahan *parsing* JSON).

Keduanya diperlukan agar aplikasi dapat membedakan mana galat dari server dan mana galat teknis pada perangkat.

### 3. Mengapa data JSON sebaiknya diubah menjadi class model, bukan dipakai langsung sebagai Map?
Agar memiliki *type safety* dan menghindari kesalahan pengetikan nama kunci (*typo*). Menggunakan class model memberikan bantuan *autocomplete* pada IDE dan membuat kode lebih rapi serta mudah dirawat dibanding mengakses `Map['key']` secara manual di banyak tempat.

### 4. Mengapa UI wajib menyediakan status loading dan error, bukan hanya status data?
Untuk memberikan pengalaman pengguna (UX) yang baik. Status *loading* memberi tahu pengguna bahwa aplikasi sedang bekerja dan tidak *freeze*, sedangkan status *error* memberikan kejelasan mengenai masalah yang terjadi beserta solusi untuk mencoba lagi.

---

---

## Mengapa Butuh FutureBuilder dan Pemrosesan Asinkron?

Mengambil data dari internet membutuhkan waktu yang tidak bisa dipastikan tergantung pada kecepatan jaringan dan respons server. Jika data diambil secara sinkron, tampilan aplikasi akan membeku (*freeze*) sampai proses download selesai. 

Solusinya: gunakan **Future** dan **FutureBuilder**. `Future` menangani pemrosesan di latar belakang tanpa mengganggu jalannya UI, sedangkan `FutureBuilder` menangani perubahan tampilan secara otomatis saat data masih dimuat, sukses diterima, atau terjadi galat.