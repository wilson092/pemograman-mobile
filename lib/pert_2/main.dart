import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// Model data kontak
class Kontak {
  final String nama;
  final String nomor;
  final String email;

  Kontak({
    required this.nama,
    required this.nomor,
    required this.email,
  });
}


final List<Kontak> daftarKontak = [
  Kontak(
    nama: 'Wilson',
    nomor: '081234567890',
    email: 'wilson@gmail.com',
  ),
  Kontak(
    nama: 'Muta',
    nomor: '081234567891',
    email: 'muta@gmail.com',
  ),
  Kontak(
    nama: 'Angga',
    nomor: '081234567892',
    email: 'angga@gmail.com',
  ),
  Kontak(
    nama: 'Riski',
    nomor: '081234567893',
    email: 'riski@gmail.com',
  ),
  Kontak(
    nama: 'Farel',
    nomor: '081234567894',
    email: 'farel@gmail.com',
  ),
  Kontak(
    nama: 'Riki',
    nomor: '081234567895',
    email: 'riki@gmail.com',
  ),
];

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Daftar Kontak',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const KontakPage(),
    );
  }
}

// Halaman daftar kontak
class KontakPage extends StatelessWidget {
  const KontakPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Kontak'),
      ),
      body: ListView.builder(
        itemCount: daftarKontak.length,
        itemBuilder: (context, index) {
          final kontak = daftarKontak[index];

          return Card(
            margin: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            child: ListTile(
              leading: CircleAvatar(
                child: Text(
                  kontak.nama[0],
                ),
              ),
              title: Text(kontak.nama),
              subtitle: Text(kontak.nomor),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailKontakPage(
                      kontak: kontak,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

// Halaman detail kontak
class DetailKontakPage extends StatelessWidget {
  final Kontak kontak;

  const DetailKontakPage({
    super.key,
    required this.kontak,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Kontak'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              child: Text(
                kontak.nama[0],
                style: const TextStyle(
                  fontSize: 40,
                ),
              ),
            ),

            const SizedBox(height: 20),

            Text(
              kontak.nama,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            ListTile(
              leading: const Icon(Icons.phone),
              title: const Text('Nomor Telepon'),
              subtitle: Text(kontak.nomor),
            ),

            ListTile(
              leading: const Icon(Icons.email),
              title: const Text('Email'),
              subtitle: Text(kontak.email),
            ),
          ],
        ),
      ),
    );
  }
}