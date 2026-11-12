import 'package:flutter/material.dart';

class CatatanScreen extends StatelessWidget {
  const CatatanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Catatan Mahasiswa')),
      body: const Center(
        child: Text(
          'Halaman Catatan Mahasiswa',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
