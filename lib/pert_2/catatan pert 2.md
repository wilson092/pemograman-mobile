1. Expanded 
Membuat widget mengisi ruang yang tersedia di dalam Row/Column

2. Card dan ListTile
- Card digunakan untuk membuat tampilan berbentuk kartu.
- ListTile digunakan untuk membuat item dalam daftar dengan struktur seperti title, subtitle, leading, dan trailing

3. ListView.builder
digunakan untuk membuat daftar yang dapat di-scroll dan cocok digunakan untuk menampilkan banyak data

4. Padding
Padding digunakan untuk memberikan jarak antara isi widget dengan bagian dalam widget.

5. Navigasi Antar Halaman
- Navigator.push() digunakan untuk membuka halaman baru
- Navigator.pop() digunakan untuk kembali ke halaman sebelumnya
- Data dapat dikirim ke halaman berikutnya melalui constructor

- Pertanyaan Refleksi
1. perbedaan ListView biasa dengan ListView.builder?
- ListView.builder membuat item sesuai kebutuhan sehingga lebih efisien untuk data yang banyak

2. Mengapa Row yang berisi teks panjang dapat menyebabkan overflow, dan bagaimana Expanded membantu?
- Karena ruang horizontal terbatas. Expanded membuat widget menggunakan ruang yang tersedia agar teks tidak keluar dari batas

3. Bagaimana data dikirim dari halaman daftar ke halaman detail?
- Data dikirim melalui constructor saat melakukan Navigator.push()

docs.flutter.dev/cookbook/navigation
docs.flutter.dev/cookbook/lists