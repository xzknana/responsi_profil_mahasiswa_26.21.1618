class Validators {
  // Validasi judul catatan.
  static String? validateTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Judul catatan wajib diisi';
    }

    final title = sanitize(value).trim();

    if (title.length < 3) {
      return 'Judul minimal 3 karakter';
    }

    if (title.length > 50) {
      return 'Judul maksimal 50 karakter';
    }

    return null;
  }

  // Validasi isi catatan.
  static String? validateContent(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Isi catatan wajib diisi';
    }

    final content = sanitize(value).trim();

    if (content.length < 10) {
      return 'Isi catatan minimal 10 karakter';
    }

    if (content.length > 1000) {
      return 'Isi catatan maksimal 1000 karakter';
    }

    return null;
  }

  // Membersihkan karakter berbahaya.
  static String sanitize(String value) {
    return value.replaceAll(RegExp(r'''[<>"']'''), '').trim();
  }
}
