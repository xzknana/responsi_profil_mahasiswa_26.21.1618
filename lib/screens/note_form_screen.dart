import 'package:flutter/material.dart';

import '../models/note.dart';
import '../providers/app_provider.dart';
import '../utils/validators.dart';

class NoteFormScreen extends StatefulWidget {
  const NoteFormScreen({super.key});

  @override
  State<NoteFormScreen> createState() => _NoteFormScreenState();
}

class _NoteFormScreenState extends State<NoteFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  // Menyimpan catatan.
  void _saveNote() {
    // Memeriksa validasi form.
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Mengambil AppProvider.
    final provider = AppProvider.of(context);

    // Sanitasi input sebelum disimpan.
    final title = Validators.sanitize(_titleController.text);

    final content = Validators.sanitize(_contentController.text);

    // Membuat objek catatan baru.
    final newNote = Note(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: title,
      content: content,
      createdAt: DateTime.now(),
    );

    // Menambahkan catatan ke AppProvider.
    provider.addNote(newNote);

    // Menutup halaman setelah berhasil.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Catatan berhasil ditambahkan!'),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Catatan'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Form(
          key: _formKey,

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Buat Catatan Baru',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 8),

              const Text(
                'Tuliskan catatan kegiatan atau materi kuliah kamu.',
                style: TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 24),

              // Input judul.
              const Text(
                'Judul Catatan',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 8),

              TextFormField(
                controller: _titleController,
                maxLength: 50,
                decoration: const InputDecoration(
                  hintText: 'Masukkan judul catatan',
                  prefixIcon: Icon(Icons.title),
                  border: OutlineInputBorder(),
                ),
                validator: Validators.validateTitle,
              ),

              const SizedBox(height: 16),

              // Input isi catatan.
              const Text(
                'Isi Catatan',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 8),

              TextFormField(
                controller: _contentController,
                maxLength: 1000,
                maxLines: 6,
                decoration: const InputDecoration(
                  hintText: 'Tuliskan isi catatan...',
                  alignLabelWithHint: true,
                  prefixIcon: Icon(Icons.notes),
                  border: OutlineInputBorder(),
                ),
                validator: Validators.validateContent,
              ),

              const SizedBox(height: 24),

              // Tombol simpan.
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _saveNote,
                  icon: const Icon(Icons.save),
                  label: const Text('Simpan Catatan'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
