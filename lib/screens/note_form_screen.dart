import 'package:flutter/material.dart';

import '../repositories/note_repository.dart';
import '../utils/validators.dart';

/// Halaman untuk menambahkan atau mengedit catatan.
class NoteFormScreen extends StatefulWidget {
  /// Metadata catatan yang akan diedit.
  ///
  /// Jika null, form digunakan untuk membuat catatan baru.
  final NoteMetadata? note;

  /// Membuat halaman form catatan.
  const NoteFormScreen({super.key, this.note});

  @override
  State<NoteFormScreen> createState() => _NoteFormScreenState();
}

class _NoteFormScreenState extends State<NoteFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final NoteRepository _repository = NoteRepository();

  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  bool _isSaving = false;
  bool _isLoadingContent = false;

  bool get _isEditing => widget.note != null;

  @override
  void initState() {
    super.initState();

    if (_isEditing) {
      _titleController.text = widget.note!.title;
      _loadContent();
    }
  }

  /// Mengambil isi catatan dari secure storage ketika mode edit dibuka.
  Future<void> _loadContent() async {
    setState(() {
      _isLoadingContent = true;
    });

    try {
      final content = await _repository.getContent(widget.note!.id);

      if (!mounted) return;

      _contentController.text = content ?? '';
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Isi catatan gagal dimuat.')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingContent = false;
        });
      }
    }
  }

  /// Memvalidasi dan menyimpan catatan melalui repository.
  Future<void> _saveNote() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final now = DateTime.now();
      final noteId = widget.note?.id ?? now.microsecondsSinceEpoch.toString();

      await _repository.saveNote(
        id: noteId,
        title: Validators.sanitize(_titleController.text),
        content: Validators.sanitize(_contentController.text),
        createdAt: widget.note?.createdAt ?? now,
      );

      if (!mounted) return;

      Navigator.pop(context, true);
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _isSaving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Catatan gagal disimpan. Silakan coba kembali.'),
        ),
      );
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Catatan' : 'Tambah Catatan'),
      ),
      body: _isLoadingContent
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _titleController,
                      maxLength: 50,
                      decoration: const InputDecoration(
                        labelText: 'Judul Catatan',
                        hintText: 'Masukkan judul catatan',
                        prefixIcon: Icon(Icons.title),
                        border: OutlineInputBorder(),
                      ),
                      validator: Validators.validateTitle,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _contentController,
                      maxLength: 1000,
                      maxLines: 8,
                      decoration: const InputDecoration(
                        labelText: 'Isi Catatan',
                        hintText: 'Tuliskan isi catatan...',
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(),
                      ),
                      validator: Validators.validateContent,
                    ),
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      onPressed: _isSaving ? null : _saveNote,
                      icon: _isSaving
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.save_outlined),
                      label: Text(
                        _isSaving ? 'Menyimpan...' : 'Simpan Catatan',
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
