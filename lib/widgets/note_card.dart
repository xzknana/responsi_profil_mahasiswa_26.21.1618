import 'package:flutter/material.dart';

import '../repositories/note_repository.dart';

/// Menampilkan metadata satu catatan dalam bentuk kartu.
class NoteCard extends StatelessWidget {
  /// Metadata catatan yang akan ditampilkan.
  final NoteMetadata note;

  /// Callback ketika kartu ditekan.
  final VoidCallback onTap;

  /// Callback ketika tombol hapus ditekan.
  final VoidCallback onDelete;

  /// Membuat kartu catatan.
  const NoteCard({
    super.key,
    required this.note,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ListTile(
        onTap: onTap,
        leading: const CircleAvatar(child: Icon(Icons.note_alt_outlined)),
        title: Text(
          note.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(_formatDate(note.createdAt)),
        trailing: IconButton(
          tooltip: 'Hapus catatan',
          icon: const Icon(Icons.delete_outline, color: Colors.red),
          onPressed: onDelete,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year;

    return '$day/$month/$year';
  }
}
