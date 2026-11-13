import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Menangani penyimpanan isi catatan menggunakan secure storage.
class SecureStorageService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  /// Menyimpan isi catatan secara terenkripsi berdasarkan ID catatan.
  Future<void> saveContent(String noteId, String content) async {
    await _storage.write(key: 'note_content_$noteId', value: content);
  }

  /// Membaca isi catatan berdasarkan ID catatan.
  ///
  /// Mengembalikan null jika isi catatan tidak ditemukan.
  Future<String?> getContent(String noteId) async {
    return await _storage.read(key: 'note_content_$noteId');
  }

  /// Menghapus isi catatan berdasarkan ID catatan.
  Future<void> deleteContent(String noteId) async {
    await _storage.delete(key: 'note_content_$noteId');
  }
}
