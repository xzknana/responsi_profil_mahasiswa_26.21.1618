import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../services/secure_storage_service.dart';

/// Merepresentasikan metadata catatan tanpa menyimpan isi catatannya.
class NoteMetadata {
  /// ID unik catatan.
  final String id;

  /// Judul catatan.
  final String title;

  /// Tanggal pembuatan catatan.
  final DateTime createdAt;

  /// Membuat objek metadata catatan.
  const NoteMetadata({
    required this.id,
    required this.title,
    required this.createdAt,
  });

  /// Mengubah metadata menjadi Map untuk format JSON.
  Map<String, dynamic> toJson() {
    return {'id': id, 'title': title, 'createdAt': createdAt.toIso8601String()};
  }

  /// Membuat metadata dari Map hasil pembacaan JSON.
  factory NoteMetadata.fromJson(Map<String, dynamic> json) {
    return NoteMetadata(
      id: json['id'] as String,
      title: json['title'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}

/// Mengelola metadata dan isi catatan melalui penyimpanan terpisah.
class NoteRepository {
  static const String _metadataKey = 'notes_metadata';

  final SecureStorageService _secureStorage;

  /// Membuat repository dengan secure storage yang dapat digunakan.
  NoteRepository({SecureStorageService? secureStorage})
    : _secureStorage = secureStorage ?? SecureStorageService();

  /// Mengambil seluruh metadata catatan dari SharedPreferences.
  Future<List<NoteMetadata>> getNotes() async {
    final preferences = await SharedPreferences.getInstance();
    final jsonString = preferences.getString(_metadataKey);

    if (jsonString == null || jsonString.isEmpty) {
      return [];
    }

    final List<dynamic> decoded = jsonDecode(jsonString) as List<dynamic>;

    return decoded.map((item) {
      return NoteMetadata.fromJson(Map<String, dynamic>.from(item as Map));
    }).toList();
  }

  /// Menyimpan metadata dan isi catatan pada penyimpanan masing-masing.
  ///
  /// Isi catatan disimpan lebih dahulu agar metadata tidak menunjuk
  /// ke isi catatan yang belum berhasil disimpan.
  Future<void> saveNote({
    required String id,
    required String title,
    required String content,
    required DateTime createdAt,
  }) async {
    final preferences = await SharedPreferences.getInstance();
    final notes = await getNotes();

    final metadata = NoteMetadata(id: id, title: title, createdAt: createdAt);

    // Simpan isi catatan di secure storage.
    await _secureStorage.saveContent(id, content);

    // Tambahkan atau perbarui metadata berdasarkan ID.
    final updatedNotes = [
      for (final note in notes)
        if (note.id != id) note,
      metadata,
    ];

    try {
      final jsonString = jsonEncode(
        updatedNotes.map((note) => note.toJson()).toList(),
      );

      final success = await preferences.setString(_metadataKey, jsonString);

      if (!success) {
        throw Exception('Metadata catatan gagal disimpan.');
      }
    } catch (_) {
      // Bersihkan isi catatan jika metadata gagal disimpan.
      await _secureStorage.deleteContent(id);
      rethrow;
    }
  }

  /// Mengambil isi catatan dari secure storage berdasarkan ID.
  Future<String?> getContent(String noteId) async {
    return _secureStorage.getContent(noteId);
  }

  /// Menghapus metadata dan isi catatan berdasarkan ID.
  Future<void> deleteNote(String noteId) async {
    final preferences = await SharedPreferences.getInstance();
    final notes = await getNotes();

    final updatedNotes = notes.where((note) => note.id != noteId).toList();

    final jsonString = jsonEncode(
      updatedNotes.map((note) => note.toJson()).toList(),
    );

    final success = await preferences.setString(_metadataKey, jsonString);

    if (!success) {
      throw Exception('Metadata catatan gagal diperbarui.');
    }

    await _secureStorage.deleteContent(noteId);
  }
}
