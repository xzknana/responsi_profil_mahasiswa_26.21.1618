import 'package:flutter/material.dart';

import '../providers/app_provider.dart';
import '../repositories/note_repository.dart';
import '../screens/profile/profile_screen.dart';
import '../widgets/note_card.dart';
import 'note_form_screen.dart';
import '../widgets/empty_state.dart';

/// Halaman utama yang menampilkan profil singkat dan daftar catatan.
class HomeScreen extends StatefulWidget {
  /// Membuat halaman utama.
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final NoteRepository _repository = NoteRepository();

  List<NoteMetadata> _notes = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  /// Mengambil metadata catatan dari repository.
  Future<void> _loadNotes() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final notes = await _repository.getNotes();

      if (!mounted) return;

      setState(() {
        _notes = notes;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _errorMessage = 'Catatan gagal dimuat. Silakan coba kembali.';
        _isLoading = false;
      });
    }
  }

  /// Membuka halaman profil mahasiswa.
  Future<void> _openProfile() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProfileScreen()),
    );
  }

  /// Membuka form catatan baru dan memuat ulang daftar jika berhasil.
  Future<void> _addNote() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (context) => const NoteFormScreen()),
    );

    if (result == true) {
      await _loadNotes();
    }
  }

  /// Menampilkan dialog konfirmasi sebelum menghapus catatan.
  Future<void> _confirmDelete(NoteMetadata note) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Hapus Catatan?'),
          content: Text('Apakah kamu yakin ingin menghapus "${note.title}"?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              style: FilledButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await _deleteNote(note);
    }
  }

  /// Menghapus catatan melalui repository.
  Future<void> _deleteNote(NoteMetadata note) async {
    try {
      await _repository.deleteNote(note.id);

      if (!mounted) return;

      await _loadNotes();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Catatan berhasil dihapus.')),
      );
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Catatan gagal dihapus. Silakan coba kembali.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final student = AppProvider.of(context).student;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Catatan Saya'),
        actions: [
          IconButton(
            onPressed: _openProfile,
            tooltip: 'Profil',
            icon: const Icon(Icons.account_circle_outlined),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildProfileHeader(student.name, student.nim),
          Expanded(child: _buildNoteContent()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNote,
        tooltip: 'Tambah catatan',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildProfileHeader(String name, String nim) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: Text(
              name.isNotEmpty ? name[0].toUpperCase() : '?',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: Theme.of(context).textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text('NIM: $nim'),
              ],
            ),
          ),
          const Icon(Icons.school_outlined),
        ],
      ),
    );
  }

  Widget _buildNoteContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 12),
              Text(_errorMessage!, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: _loadNotes,
                icon: const Icon(Icons.refresh),
                label: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
      );
    }

    if (_notes.isEmpty) {
      return const EmptyState();
    }

    return RefreshIndicator(
      onRefresh: _loadNotes,
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 80),
        itemCount: _notes.length,
        itemBuilder: (context, index) {
          final note = _notes[index];

          return NoteCard(
            note: note,
            onTap: () async {
              final result = await Navigator.push<bool>(
                context,
                MaterialPageRoute(
                  builder: (context) => NoteFormScreen(note: note),
                ),
              );

              if (result == true) {
                await _loadNotes();
              }
            },
            onDelete: () => _confirmDelete(note),
          );
        },
      ),
    );
  }
}
