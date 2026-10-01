//tugas 1 kartu pengenalan
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Kartu Perkenalan'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(
                Icons.person,
                size: 100,
                color: Colors.blue,
              ),
              SizedBox(height: 16),
              Text(
                'Wilson Fabian',
                style: TextStyle(fontSize: 24),
              ),
              Text('NIM: 20240801098'),
              Text('Teknik Informatika'),
              Text('Hobi: Mendengarkan musik'),
            ],
          ),
        ),
      ),
    );
  }
}