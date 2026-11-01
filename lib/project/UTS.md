# UTS Pemrograman Mobile

## WeatherInsight Mobile

![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart&logoColor=white)
![Platform](https://img.shields.io/badge/Platform-Android-3DDC84?logo=android&logoColor=white)
![Status](https://img.shields.io/badge/Status-Prototipe-orange)

---

## Daftar Isi

1. [Identitas & Tentang Proyek](#1-identitas--tentang-proyek)
2. [Wireframe (Low-Fidelity)](#2-wireframe-low-fidelity)
3. [Mockup (High-Fidelity)](#3-mockup-high-fidelity)
4. [Panduan Menjalankan, Troubleshooting & Struktur File](#4-panduan-menjalankan-troubleshooting--struktur-file)
5. [Pengembangan Lanjutan](#5-pengembangan-lanjutan)

---

## 1. Identitas & Tentang Proyek

### Identitas Mahasiswa

| | |
|---|---|
| **Nama** | Wilson Fabian |
| **NIM** | 20240801098 |
| **Program Studi** | Teknik Informatika |
| **Fakultas** | Ilmu Komputer |
| **Mata Kuliah** | Pemrograman Mobile CR002 |
| **Tugas** | Ujian Tengah Semester |

### Tentang Proyek

**WeatherInsight Mobile** adalah prototipe aplikasi mobile informasi dan manajemen cuaca yang dibuat dengan **Flutter**. Aplikasi mengikuti desain antarmuka (wireframe dan mockup) yang sudah dirancang sebelumnya.

Aplikasi memiliki dua peran:

- **Pengguna**: melihat cuaca saat ini, prakiraan, kota favorit, peta cuaca, dan perbandingan cuaca antar kota.
- **Administrator**: memantau statistik, mengatur ambang batas risiko cuaca (*weather rules*), mengelola peran dan pengguna, serta melihat log aktivitas dan log API.

Saat ini aplikasi masih berupa **prototipe antarmuka**: tampilan dan alur navigasi sudah dapat dicoba, tetapi fitur-fiturnya belum berfungsi penuh dan masih menggunakan **data contoh (mock)**, sehingga dapat diuji tanpa server. Rencana penyempurnaan fitur dijelaskan pada bagian [Pengembangan Lanjutan](#5-pengembangan-lanjutan).

### Dokumen dan Desain

| Dokumen | Tautan |
|---|---|
| Business Requirement Document | [BRD - WeatherInsight Mobile.pdf](docs-project/BRD%20-%20WeatherInsight%20Mobile.pdf) |
| Product Requirement Document | [PRD WeatherInsight Mobile.pdf](docs-project/PRD%20WeatherInsight%20Mobile.pdf) |
| Desain Figma | https://www.figma.com/design/11AOeekQsNOjnykQvIHpL3/Mockup---WeatherInsight---Pemograman-Mobile-CR002?node-id=0-1&t=7HM2k9nTwd14BD7z-0 |

---

## 2. Wireframe (Low-Fidelity)

Wireframe berada di folder [`docs-project/wireframe/`](docs-project/wireframe/).

### 2.1 Sisi Pengguna

<table>
  <tr>
    <td align="center" valign="top" width="33%"><img src="docs-project/wireframe/Wireframe%20-%20Login%20WeatherInsight.png" alt="Wireframe Login" height="420"></td>
    <td align="center" valign="top" width="33%"><img src="docs-project/wireframe/Wireframe%20-%20Beranda%20Cuaca.png" alt="Wireframe Beranda" height="420"></td>
    <td align="center" valign="top" width="33%"><img src="docs-project/wireframe/Wireframe%20-%20Prakiraan%20%26%20Favorit.png" alt="Wireframe Prakiraan" height="420"></td>
  </tr>
  <tr>
    <td align="center" valign="top"><b>Login</b></td>
    <td align="center" valign="top"><b>Beranda Cuaca</b></td>
    <td align="center" valign="top"><b>Prakiraan &amp; Favorit</b></td>
  </tr>
  <tr>
    <td align="center" valign="top"><sub>Otentikasi multi-peran</sub></td>
    <td align="center" valign="top"><sub>Cuaca saat ini, angin, kelembapan, ISPU</sub></td>
    <td align="center" valign="top"><sub>Prakiraan 3 jam &amp; 5 hari, kota favorit</sub></td>
  </tr>
  <tr>
    <td align="center" valign="top" width="33%"><img src="docs-project/wireframe/Wireframe%20-%20Peta%20Cuaca%20%28Detail%20Lokasi%29.png" alt="Wireframe Peta" height="420"></td>
    <td align="center" valign="top" width="33%"><img src="docs-project/wireframe/Wireframe%20-%20Perbandingan%20Cuaca.png" alt="Wireframe Perbandingan" height="420"></td>
    <td width="33%"></td>
  </tr>
  <tr>
    <td align="center" valign="top"><b>Peta Cuaca</b></td>
    <td align="center" valign="top"><b>Perbandingan Cuaca</b></td>
    <td></td>
  </tr>
  <tr>
    <td align="center" valign="top"><sub>Peta spasial, pin risiko, pop-up cuaca</sub></td>
    <td align="center" valign="top"><sub>Komparasi metrik 2 kota</sub></td>
    <td></td>
  </tr>
</table>

### 2.2 Sisi Administrator

<table>
  <tr>
    <td align="center" valign="top" width="33%"><img src="docs-project/wireframe/Wireframe%20-%20Admin%20-%20Dashboard%20Admin.png" alt="Wireframe Dashboard Admin" height="420"></td>
    <td align="center" valign="top" width="33%"><img src="docs-project/wireframe/Wireframe%20-%20Admin%20-%20Weather%20Rules.png" alt="Wireframe Weather Rules" height="420"></td>
    <td align="center" valign="top" width="33%"><img src="docs-project/wireframe/Wireframe%20-%20Admin%20-%20Manajemen%20Peran.png" alt="Wireframe Manajemen Peran" height="420"></td>
  </tr>
  <tr>
    <td align="center" valign="top"><b>Dashboard Admin</b></td>
    <td align="center" valign="top"><b>Weather Rules</b></td>
    <td align="center" valign="top"><b>Manajemen Peran</b></td>
  </tr>
  <tr>
    <td align="center" valign="top"><sub>Statistik, audit trail, status server</sub></td>
    <td align="center" valign="top"><sub>Ambang batas risiko cuaca</sub></td>
    <td align="center" valign="top"><sub>Distribusi peran Admin &amp; Pengguna</sub></td>
  </tr>
  <tr>
    <td align="center" valign="top" width="33%"><img src="docs-project/wireframe/Wireframe%20-%20Admin%20-%20Manajemen%20Pengguna.png" alt="Wireframe Manajemen Pengguna" height="420"></td>
    <td align="center" valign="top" width="33%"><img src="docs-project/wireframe/Wireframe%20-%20Admin%20-%20Log%20Aktivitas.png" alt="Wireframe Log Aktivitas" height="420"></td>
    <td align="center" valign="top" width="33%"><img src="docs-project/wireframe/Wireframe%20-%20Admin%20-%20Log%20API.png" alt="Wireframe Log API" height="420"></td>
  </tr>
  <tr>
    <td align="center" valign="top"><b>Manajemen Pengguna</b></td>
    <td align="center" valign="top"><b>Log Aktivitas</b></td>
    <td align="center" valign="top"><b>Log API</b></td>
  </tr>
  <tr>
    <td align="center" valign="top"><sub>Daftar &amp; status pengguna</sub></td>
    <td align="center" valign="top"><sub>Audit trail sistem</sub></td>
    <td align="center" valign="top"><sub>Endpoint &amp; latensi</sub></td>
  </tr>
</table>

---

## 3. Mockup (High-Fidelity)

Mockup berada di folder [`docs-project/mockup/`](docs-project/mockup/).

### 3.1 Sisi Pengguna

<table>
  <tr>
    <td align="center" valign="top" width="33%"><img src="docs-project/mockup/Mockup%20-%20Login%20WeatherInsight.png" alt="Mockup Login" height="420"></td>
    <td align="center" valign="top" width="33%"><img src="docs-project/mockup/Mockup%20-Beranda%20-%20WeatherInsight.png" alt="Mockup Beranda" height="420"></td>
    <td align="center" valign="top" width="33%"><img src="docs-project/mockup/Mockup%20-%20Prakiraan%20Cuaca%20%26%20Favorit.png" alt="Mockup Prakiraan" height="420"></td>
  </tr>
  <tr>
    <td align="center" valign="top"><b>Login</b></td>
    <td align="center" valign="top"><b>Beranda</b></td>
    <td align="center" valign="top"><b>Prakiraan &amp; Favorit</b></td>
  </tr>
  <tr>
    <td align="center" valign="top"><sub>Masuk sesuai peran</sub></td>
    <td align="center" valign="top"><sub>Cuaca saat ini, analisis risiko, ISPU</sub></td>
    <td align="center" valign="top"><sub>Prakiraan dan kota favorit</sub></td>
  </tr>
  <tr>
    <td align="center" valign="top" width="33%"><img src="docs-project/mockup/Mockup%20-%20Peta%20Cuaca%20-%20WeatherInsight.png" alt="Mockup Peta Cuaca" height="420"></td>
    <td align="center" valign="top" width="33%"><img src="docs-project/mockup/Mockup%20-%20Perbandingan%20Cuaca%20-%20WeatherInsight.png" alt="Mockup Perbandingan" height="420"></td>
    <td width="33%"></td>
  </tr>
  <tr>
    <td align="center" valign="top"><b>Peta Cuaca</b></td>
    <td align="center" valign="top"><b>Perbandingan Cuaca</b></td>
    <td></td>
  </tr>
  <tr>
    <td align="center" valign="top"><sub>Peta dengan detail lokasi</sub></td>
    <td align="center" valign="top"><sub>Bandingkan cuaca 2 kota</sub></td>
    <td></td>
  </tr>
</table>

### 3.2 Sisi Administrator

<table>
  <tr>
    <td align="center" valign="top" width="33%"><img src="docs-project/mockup/Mockup%20-%20Admin%20-%20Dashboard%20Statistik.png" alt="Mockup Dashboard Statistik" height="420"></td>
    <td align="center" valign="top" width="33%"><img src="docs-project/mockup/Mockup%20-%20Admin%20-%20Weather%20Rules.png" alt="Mockup Weather Rules" height="420"></td>
    <td align="center" valign="top" width="33%"><img src="docs-project/mockup/Mockup%20-%20Admin%20-%20Manajemen%20Peran.png" alt="Mockup Manajemen Peran" height="420"></td>
  </tr>
  <tr>
    <td align="center" valign="top"><b>Dashboard Statistik</b></td>
    <td align="center" valign="top"><b>Weather Rules</b></td>
    <td align="center" valign="top"><b>Manajemen Peran</b></td>
  </tr>
  <tr>
    <td align="center" valign="top"><sub>Ringkasan statistik &amp; menu pengelolaan</sub></td>
    <td align="center" valign="top"><sub>Ambang batas risiko cuaca</sub></td>
    <td align="center" valign="top"><sub>Distribusi &amp; ubah peran pengguna</sub></td>
  </tr>
  <tr>
    <td align="center" valign="top" width="33%"><img src="docs-project/mockup/Mockup%20-%20Admin%20-%20Manajemen%20Pengguna.png" alt="Mockup Manajemen Pengguna" height="420"></td>
    <td align="center" valign="top" width="33%"><img src="docs-project/mockup/Mockup%20-%20Admin%20-%20Log%20Aktivitas.png" alt="Mockup Log Aktivitas" height="420"></td>
    <td align="center" valign="top" width="33%"><img src="docs-project/mockup/Mockup%20-%20Admin%20-%20Log%20API.png" alt="Mockup Log API" height="420"></td>
  </tr>
  <tr>
    <td align="center" valign="top"><b>Manajemen Pengguna</b></td>
    <td align="center" valign="top"><b>Log Aktivitas</b></td>
    <td align="center" valign="top"><b>Log API</b></td>
  </tr>
  <tr>
    <td align="center" valign="top"><sub>Daftar &amp; status pengguna</sub></td>
    <td align="center" valign="top"><sub>Audit trail sistem</sub></td>
    <td align="center" valign="top"><sub>Endpoint &amp; latensi</sub></td>
  </tr>
</table>

### 3.3 Sistem Desain

| Aspek | Penjelasan |
|---|---|
| **Palet warna** | Tampilan bersih dengan kontras tinggi; warna hijau, kuning, dan merah untuk tingkat risiko (Rendah, Sedang, Tinggi) |
| **Tipografi** | Font kustom dari `assets/fonts/` dengan hierarki judul, subjudul, dan isi yang konsisten |
| **Komponen** | Komponen yang sama dipakai di semua layar: top bar, bottom navigation, kartu statistik, chip risiko, tombol utama |

---

## 4. Panduan Menjalankan, Troubleshooting & Struktur File

### 4.1 Prasyarat

- Flutter SDK (versi `>= 3.5.3`) dan Dart SDK
- Android Studio atau VS Code dengan ekstensi Flutter & Dart
- Emulator Android, perangkat fisik (USB Debugging aktif), atau Chrome (Web)

### 4.2 Langkah Menjalankan

**1. Clone repository**

```bash
git clone https://github.com/wilson092/pemograman-mobile.git
cd pemograman-mobile
```

**2. Install dependensi**

```bash
flutter pub get
```

**3. Verifikasi lingkungan**

```bash
flutter doctor
flutter devices
```

**4. Jalankan aplikasi**

> **Penting:** folder `lib/` juga berisi tugas mingguan (`pert_1` s/d `pert_14`), sehingga *entry point* WeatherInsight harus ditentukan secara spesifik, yaitu `lib/project/app/main.dart`.

```bash
# Device / emulator default
flutter run -t lib/project/app/main.dart

# Memilih device tertentu (contoh: emulator Android)
flutter run -t lib/project/app/main.dart -d emulator-5554

# Menjalankan di Chrome (Web)
flutter run -t lib/project/app/main.dart -d chrome

# Mode release
flutter run -t lib/project/app/main.dart --release
```

**5. Jalankan pengujian dan analisis kode**

```bash
flutter test
flutter analyze lib/project/app/ test/
```

### 4.3 Alur Mencoba Aplikasi

| Langkah | Peran | Yang dicoba |
|---|---|---|
| 1 | Pengguna | Login, lalu buka **Beranda** (cuaca saat ini, angin, kelembapan, ISPU) |
| 2 | Pengguna | Buka **Prakiraan & Favorit**, **Peta Cuaca**, dan **Perbandingan Cuaca** |
| 3 | Administrator | Login sebagai admin, lihat **Dashboard Statistik** |
| 4 | Administrator | Coba **Weather Rules**, **Manajemen Peran**, **Manajemen Pengguna**, **Log Aktivitas**, dan **Log API** |

### 4.4 Troubleshooting

| Masalah | Solusi |
|---|---|
| `flutter devices` tidak menampilkan perangkat | Jalankan emulator terlebih dahulu atau aktifkan USB Debugging |
| `adb: failed to check server version` / `Address already in use` | Matikan ADB lalu jalankan ulang: `adb kill-server && adb start-server` |
| Aplikasi yang terbuka bukan WeatherInsight | Pastikan memakai `-t lib/project/app/main.dart` |
| Error dependensi setelah clone | Jalankan `flutter clean` lalu `flutter pub get` |

### 4.5 Struktur File (`lib/project/app/`)

```text
lib/project/app/
├── main.dart
├── core/          # Tema (app_colors.dart), tipografi, dimensi, routing GoRouter
├── data/          # Model, mock repository, provider Riverpod
├── features/      # Modul per fitur
│   ├── auth/
│   ├── home/
│   ├── map/
│   ├── compare/
│   └── admin/
└── widgets/       # Komponen UI reusable
```

| Folder | Isi |
|---|---|
| `core/` | Warna (`app_colors.dart`), tipografi, dimensi, dan routing dengan **GoRouter** |
| `data/` | Model (`weather_data`, `risk_rules`, `role`, dll), mock repository (`mock_weather_repository.dart`, `mock_admin_repository.dart`), dan state provider **Riverpod** |
| `features/` | Pemisahan modular per fitur: `auth`, `home`, `map`, `compare`, `admin` |
| `widgets/` | Komponen reusable: TopBar, BottomNav, StatCard, RiskChip, PrimaryButton, dll |



## 5. Pengembangan Lanjutan

Aplikasi pada saat ini masih berstatus **prototipe**. Fokusnya adalah menyajikan antarmuka dan alur navigasi sesuai desain, sedangkan fitur-fiturnya belum berfungsi penuh. Fitur-fitur yang sudah tampil sebagai layar akan dilengkapi pada tahap pengembangan berikutnya.

### 5.1 Rencana Pengembangan Fitur

| Fitur | Kondisi Saat Ini (Prototipe) | Rencana Pengembangan |
|---|---|---|
| **Login & Peran** | Tampilan login dan pemisahan layar Pengguna / Admin | Otentikasi sungguhan dan pembatasan akses berdasarkan peran |
| **Beranda Cuaca** | Menampilkan data cuaca contoh | Data cuaca real-time sesuai lokasi pengguna |
| **Prakiraan & Favorit** | Tampilan prakiraan dan daftar kota favorit | Prakiraan dari API dan penyimpanan kota favorit per pengguna |
| **Peta Cuaca** | Tampilan peta dengan pin dan detail lokasi | Peta interaktif dengan data cuaca dan risiko tiap lokasi |
| **Perbandingan Cuaca** | Tampilan perbandingan 2 kota dengan data contoh | Pembandingan cuaca antar kota secara dinamis dengan data nyata |
| **Weather Rules (Admin)** | Tampilan ambang batas risiko | Ambang batas dapat diubah dan langsung memengaruhi analisis risiko |
| **Manajemen Peran & Pengguna** | Tampilan daftar peran dan pengguna | Tambah, ubah, dan nonaktifkan pengguna serta pengaturan peran |
| **Log Aktivitas & Log API** | Tampilan log dengan data contoh | Pencatatan aktivitas dan permintaan API yang sebenarnya |

### 5.2 Tahapan yang Direncanakan

| Tahap | Pekerjaan |
|---|---|
| 1 | Menghubungkan aplikasi ke **OpenWeather API** dengan membuat repository baru (tanpa mengubah layer UI) |
| 2 | Melengkapi fitur utama sisi Pengguna: beranda, prakiraan, favorit, peta, dan perbandingan cuaca |
| 3 | Melengkapi fitur sisi Administrator: weather rules, manajemen peran dan pengguna, serta log |
| 4 | Menambahkan otentikasi, penyimpanan data ke backend, dan pengujian menyeluruh |

Arsitektur *Repository Pattern* yang sudah dipakai pada prototipe ini membuat transisi dari data mock ke data nyata dapat dilakukan tanpa merombak tampilan.