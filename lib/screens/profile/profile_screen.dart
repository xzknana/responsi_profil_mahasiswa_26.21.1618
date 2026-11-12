import 'package:flutter/material.dart';

import '../../models/mahasiswa.dart';
import '../../controllers/mahasiswa_controller.dart';
import '../../widgets/profile_card.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final MahasiswaController _controller;

  @override
  void initState() {
    super.initState();
    _controller = MahasiswaController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Menampilkan dialog edit profil.
  Future<void> _showEditDialog() async {
    final student = _controller.mahasiswa;

    final nameController = TextEditingController(text: student.name);

    final nimController = TextEditingController(text: student.nim);

    final programController = TextEditingController(text: student.programStudi);

    final emailController = TextEditingController(text: student.email);

    final updatedStudent = await showDialog<Mahasiswa>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Edit Profil Mahasiswa'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nama',
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: nimController,
                  decoration: const InputDecoration(
                    labelText: 'NIM',
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: programController,
                  decoration: const InputDecoration(
                    labelText: 'Program Studi',
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Batal'),
            ),

            ElevatedButton(
              onPressed: () {
                // Validasi input sederhana.
                if (nameController.text.trim().isEmpty ||
                    nimController.text.trim().isEmpty ||
                    programController.text.trim().isEmpty ||
                    emailController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    const SnackBar(content: Text('Semua field wajib diisi!')),
                  );
                  return;
                }

                final newStudent = student.copyWith(
                  name: nameController.text.trim(),
                  nim: nimController.text.trim(),
                  programStudi: programController.text.trim(),
                  email: emailController.text.trim(),
                );

                Navigator.pop(dialogContext, newStudent);
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );

    // Memperbarui data jika pengguna menekan Simpan.
    if (updatedStudent != null) {
      _controller.updateStudent(updatedStudent);
    }

    // Membersihkan controller input.
    nameController.dispose();
    nimController.dispose();
    programController.dispose();
    emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        title: const Text('Profil Mahasiswa'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),

      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),

                // Menampilkan kartu profil.
                ProfileCard(student: _controller.mahasiswa),

                const SizedBox(height: 20),

                // Tombol edit profil.
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: ElevatedButton.icon(
                    onPressed: _showEditDialog,
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit Profil'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
