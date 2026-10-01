import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Latihan Mandiri',
      home: const CounterPage(),
    );
  }
}

class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  int _count = 0;

  void tambah() {
    setState(() {
      _count++;
    });
  }

  void kurang() {
    setState(() {
      if (_count > 0) {
        _count--;
      }
    });
  }

  void reset() {
    setState(() {
      _count = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Latihan Counter',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.red,
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Nilai Counter',
              style: TextStyle(
                fontSize: 20,
                color: Colors.blue,
              ),
            ),

            const SizedBox(height: 16),

            Text(
              '$_count',
              style: const TextStyle(
                fontSize: 48,
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Tombol kurang
                ElevatedButton(
                  onPressed: kurang,
                  child: const Icon(Icons.remove),
                ),

                const SizedBox(width: 12),

                // Tombol tambah
                ElevatedButton(
                  onPressed: tambah,
                  child: const Icon(Icons.add),
                ),

                const SizedBox(width: 12),

                // Tombol reset
                ElevatedButton(
                  onPressed: reset,
                  child: const Icon(Icons.refresh),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}