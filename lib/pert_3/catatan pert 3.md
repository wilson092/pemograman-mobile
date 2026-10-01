Yang Dipelajari
1. TextField dan TextEditingController
TextField digunakan untuk menerima input teks dari pengguna.
TextEditingController digunakan untuk membaca nilai yang dimasukkan ke TextField.
Controller harus di-dispose() agar tidak terjadi kebocoran memori.

2. Form dan Validasi
Form digunakan untuk mengelompokkan beberapa input yang perlu divalidasi.
TextFormField digunakan untuk membuat input yang memiliki validasi.
validator digunakan untuk menentukan apakah input valid atau menampilkan pesan error.
Dropdown digunakan untuk memilih satu pilihan.
Checkbox digunakan untuk pilihan yang dapat dicentang.

3. setState

setState() digunakan untuk memperbarui tampilan ketika state pada satu halaman berubah.

4. State Management

State management digunakan untuk mengelola data yang digunakan oleh beberapa widget atau halaman.

State lokal dapat menggunakan setState().
State yang digunakan oleh banyak halaman dapat menggunakan Provider dan ChangeNotifier.

5. ChangeNotifier dan Provider
ChangeNotifier digunakan sebagai tempat menyimpan dan mengubah state.
notifyListeners() memberi tahu widget bahwa data telah berubah sehingga tampilan dapat diperbarui.
Provider digunakan untuk membagikan state ke beberapa widget atau halaman.

6. context.watch dan context.read
context.watch<T>() digunakan untuk membaca data dan ikut membangun ulang widget ketika data berubah.
context.read<T>() digunakan untuk membaca data tanpa membuat widget membangun ulang ketika data berubah.

- Pertanyaan Refleksi

1. Mengapa TextEditingController harus di-dispose?
- Agar controller dilepas setelah tidak digunakan dan mencegah kebocoran memori

2. Kapan cukup memakai setState, dan kapan sebaiknya beralih ke Provider?
- setState() cukup untuk state yang hanya digunakan dalam satu halaman/widget. Provider digunakan ketika state perlu dibagikan oleh beberapa widget atau halaman

4. Apa yang terjadi bila notifyListeners() lupa dipanggil? Mengapa?
- Perubahan data tidak langsung memperbarui widget yang menggunakan context.watch() karena widget tidak mendapat pemberitahuan bahwa state telah berubah

docs.flutter.dev/cookbook/forms
docs.flutter.dev/cookbook/navigation
docs.flutter.dev/cookbook/lists


- Mengapa Butuh State Management?

Pada Bagian A dan B, state hidup di dalam satu halaman (setState). Bayangkan aplikasi daftar tugas:
halaman daftar menampilkan tugas, sedangkan halaman tambah membuat tugas baru. Kedua halaman
perlu berbagi data yang sama. Mengoper data lewat constructor dan callback dari satu halaman ke
halaman lain cepat menjadi rumit.

Solusinya: pindahkan data ke satu objek bersama yang dapat diakses
kedua halaman. Inilah peran Provider