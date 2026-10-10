## Yang Dipelajari

### 1. Tema (ThemeData dan ThemeMode)
* **ThemeData** menyimpan seluruh gaya aplikasi (warna, tipografi, gaya komponen). Cukup satu **seed color** (`colorSchemeSeed`), Material 3 membuat seluruh palet warnanya.
* **MaterialApp** menerima `theme` (terang), `darkTheme` (gelap), dan `themeMode` (sistem/terang/gelap).
* **ValueNotifier + ListenableBuilder** membangun ulang `MaterialApp` saat mode atau warna tema berubah, tanpa restart.
* **Theme.of(context)** dipakai untuk membaca warna (`colorScheme`) dan gaya teks (`textTheme)`, sehingga tampilan otomatis menyesuaikan tema, tidak perlu menulis warna manual.

### 2. Named Routes dan Argumen
* **Named routes** memberi nama pada halaman (`'/'`, `'/detail'`) sehingga navigasi lebih rapi dan terpusat lewat `initialRoute`, `routes`, dan `onGenerateRoute`.
* **Navigator.pushNamed(ctx, '/detail', arguments: x)** membuka halaman bernama sambil membawa argumen, yang dibaca di `onGenerateRoute` lewat `settings.arguments`.
* Method lain: `pop` (menutup halaman), `pushReplacementNamed` (mengganti halaman), dan `pushNamedAndRemoveUntil` (menghapus riwayat).
* **onUnknownRoute** menangani rute yang tidak dikenal (halaman 404).

### 3. Navigasi Tab Bawah
* **NavigationBar** dengan `NavigationDestination` membuat navigasi tab di bawah layar.
* **IndexedStack** menampilkan satu tab sekaligus dan menjaga state setiap tab tetap hidup saat berpindah, berbeda dengan `Navigator` yang menumpuk halaman baru.

### 4. Animasi Implisit
* **AnimatedContainer**, **AnimatedOpacity**, dan **AnimatedSwitcher** menganimasikan perubahan nilai secara otomatis cukup lewat `setState`.
* **AnimatedSwitcher** membutuhkan `key` yang berbeda (misalnya `ValueKey`) pada anaknya agar dikenali sebagai widget baru.

### 5. Transisi Hero
* **Hero** membuat elemen "terbang" mulus antar dua halaman.
* Kedua Hero harus memakai **tag yang sama**, dan tag harus unik di dalam satu halaman.

### 6. Animasi Eksplisit
* **AnimationController** memberi kontrol penuh (ulang, berhenti, urutan), dipakai bersama widget seperti **RotationTransition** dan **ScaleTransition**.
* Membutuhkan **vsync** lewat `SingleTickerProviderStateMixin`.
* Wajib di-**dispose()** agar tidak terjadi kebocoran memori.