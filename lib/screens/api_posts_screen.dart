import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../config/app_config.dart';

/// Menampilkan daftar postingan dari API publik.
class ApiPostsScreen extends StatefulWidget {
  /// Membuat halaman daftar postingan.
  const ApiPostsScreen({super.key});

  @override
  State<ApiPostsScreen> createState() => _ApiPostsScreenState();
}

class _ApiPostsScreenState extends State<ApiPostsScreen> {
  List<dynamic> _posts = [];
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  /// Mengambil daftar postingan dari API JSONPlaceholder.
  Future<void> _fetchPosts() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final baseUrl = AppConfig.baseUrl;
      final uri = Uri.parse('$baseUrl/posts');

      final response = await http.get(uri).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List<dynamic>;

        if (!mounted) return;

        setState(() {
          _posts = data;
          _isLoading = false;
        });
      } else {
        throw HttpException(
          'Server mengembalikan status ${response.statusCode}.',
        );
      }
    } on SocketException {
      _setError('Tidak dapat terhubung ke internet.');
    } on HttpException {
      _setError('Terjadi kesalahan saat mengambil data dari server.');
    } on FormatException {
      _setError('Format data dari server tidak valid.');
    } on Exception catch (_) {
      _setError('Terjadi kesalahan. Silakan coba kembali.');
    }
  }

  /// Mengatur pesan kesalahan tanpa mencetak data sensitif ke log.
  void _setError(String message) {
    if (!mounted) return;

    setState(() {
      _errorMessage = message;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API Posts'),
        actions: [
          IconButton(
            onPressed: _isLoading ? null : _fetchPosts,
            icon: const Icon(Icons.refresh),
            tooltip: 'Muat ulang',
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
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
              ElevatedButton(
                onPressed: _fetchPosts,
                child: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
      );
    }

    if (_posts.isEmpty) {
      return const Center(child: Text('Belum ada data.'));
    }

    return ListView.builder(
      itemCount: _posts.length,
      itemBuilder: (context, index) {
        final post = _posts[index];

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: ListTile(
            leading: CircleAvatar(child: Text('${post['id']}')),
            title: Text(
              post['title'] ?? 'Tanpa judul',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              post['body'] ?? '',
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        );
      },
    );
  }
}
