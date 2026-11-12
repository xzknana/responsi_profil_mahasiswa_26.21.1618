import 'package:flutter/material.dart';

import '../models/mahasiswa.dart';

class MahasiswaController extends ChangeNotifier {
  // Data awal mahasiswa.
  Mahasiswa _mahasiswa = Mahasiswa(
    name: 'Rissa Rizkika',
    nim: '26.21.1618',
    programStudi: 'S1 Informatika',
    email: 'r.rizkika@students.amikom.ac.id',
  );

  // Getter untuk mengambil data mahasiswa.
  Mahasiswa get mahasiswa => _mahasiswa;

  // Method untuk memperbarui data mahasiswa.
  void updateStudent(Mahasiswa newMahasiswa) {
    _mahasiswa = newMahasiswa;

    // Memberitahu widget bahwa data berubah.
    notifyListeners();
  }
}
