class Mahasiswa {
  final String name;
  final String nim;
  final String programStudi;
  final String email;

  Mahasiswa({
    required this.name,
    required this.nim,
    required this.programStudi,
    required this.email,
  });

  // Membuat objek Student baru dengan data yang diperbarui.
  Mahasiswa copyWith({
    String? name,
    String? nim,
    String? programStudi,
    String? email,
  }) {
    return Mahasiswa(
      name: name ?? this.name,
      nim: nim ?? this.nim,
      programStudi: programStudi ?? this.programStudi,
      email: email ?? this.email,
    );
  }
}
