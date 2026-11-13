import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Mengelola konfigurasi aplikasi yang dimuat dari file .env.
class AppConfig {
  /// URL dasar API yang digunakan aplikasi.
  static String get baseUrl =>
      dotenv.env['BASE_URL'] ?? 'https://jsonplaceholder.typicode.com';

  /// API key aplikasi.
  ///
  /// Nilai ini hanya konfigurasi dummy untuk keperluan tugas.
  static String get apiKey => dotenv.env['API_KEY'] ?? '';

  /// Memuat konfigurasi dari file .env.
  static Future<void> load() async {
    await dotenv.load(fileName: '.env');
  }
}
