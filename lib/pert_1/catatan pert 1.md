-  yang di pelajari

1. materialApp dan scaffold: struktur dasar visual dan tema aplikasi
2. column dan Row: nyusun widget secara vertikal atau horizontal
3. text, Icon, dan SizedBox: menampilkan teks,ikon,dan memberi jarak antar elemen

4. StatelessWidget: tampilan statis/tidak berubah  
5. StatefulWidget: tampilan dinamis yang dapat berubah pakai setstate()

- materialApp: parent digunakan untuk membungkus komponen di dalamnya 
- scaffold = child dari material app


- pertanyaan refleksi 
1. Beda StatelessWidget dan StatefulWidget:
	StatelessWidget: Tampilan statis (tidak berubah)
	StatefulWidget: Tampilan dinamis (bisa berubah saat aplikasi berjalan)

2. Alasan butuh setState():
	Untuk memicu render ulang (re-build) layar. Tanpa setState(), data di memori berubah tapi angka di layar HP tidak ikut berganti.

3. Keuntungan Hot Reload:
	cepat dan data tidak hilang / tidak ke-reset ke awal saat kode diubah.


https://docs.flutter.dev/ui/widgets

