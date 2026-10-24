# WeatherInsight

**Sistem Monitoring dan Analisis Risiko Cuaca Berbasis Mobile**

WeatherInsight adalah aplikasi mobile (Android dan iOS) yang mengubah data cuaca mentah menjadi informasi yang mudah dipahami dan siap dipakai untuk mengambil keputusan. Selain menampilkan kondisi cuaca, aplikasi ini memberikan analisis risiko otomatis, informasi kualitas udara (ISPU), perbandingan cuaca antar kota, dan peta interaktif.

Project ini disusun sebagai **Project Akhir Mata Kuliah Pemrograman Mobile (CR002)**.

## Identitas

| | |
|---|---|
| **Nama** | Wilson Fabian |
| **NIM** | 202408010988 |
| **Mata Kuliah** | Pemrograman Mobile (CR002) |

## Latar Belakang

Aplikasi cuaca pada umumnya hanya menampilkan data mentah seperti suhu, kelembapan, tekanan udara, dan kecepatan angin. Pengguna harus menafsirkan sendiri apakah kondisi tersebut aman atau berisiko untuk aktivitasnya. WeatherInsight dibuat untuk menjawab masalah itu dengan mengolah data dari OpenWeather API menjadi kategori risiko (Rendah, Sedang, Tinggi) dan informasi yang lebih actionable.

## Pengguna

- **Pengguna umum**: mencari cuaca kota, melihat prakiraan dan analisis risiko, mengecek kualitas udara, membandingkan kota, menyimpan kota favorit, dan menjelajah peta cuaca.
- **Administrator**: mengelola aturan analisis risiko (Weather Rules), memantau log API dan log aktivitas, serta mengelola pengguna dan peran melalui dashboard admin.

## Fitur Utama

### Modul Pengguna
- Pencarian kota dan kondisi cuaca real-time
- Prakiraan cuaca 5 hari dan per 3 jam (24 jam ke depan)
- Analisis risiko cuaca otomatis (Rendah, Sedang, Tinggi)
- Kualitas udara berdasarkan ISPU
- Perbandingan cuaca dua kota
- Kota favorit dalam bentuk card di dashboard
- Peta cuaca interaktif dengan card indeks cuaca pada titik yang dipilih
- Login dengan akun Google (OAuth)

### Modul Admin
- Login admin
- Dashboard statistik
- Log API dan log aktivitas (retensi 90 hari)
- Manajemen pengguna dan peran
- Manajemen Weather Rules (rentang suhu tiga tingkat risiko, tanpa ubah kode)
- Daftar kota terpantau

## Teknologi

| Komponen | Teknologi |
|---|---|
| Frontend | Flutter (Dart), Material Design 3 |
| Backend | FastAPI (Python), REST API |
| Autentikasi | JWT dan Google OAuth |
| Database | SQLite |
| Cache | Cache server-side bersama pengguna (masa berlaku 10 menit) |
| API Cuaca | OpenWeather API |
| Peta | flutter_map (OpenStreetMap) |
| Deployment | Docker, Nginx |
| Version Control | Git dan GitHub |

## Dokumentasi

Rancangan lengkap project (latar belakang, user story, sitemap, wireframe, spesifikasi fitur, model data, dan acceptance criteria) tersedia pada dokumen **PRD WeatherInsight** dan **BRD WeatherInsight** .

---

&copy; 2026 Wilson Fabian (202408010988). Dibuat untuk keperluan akademik.