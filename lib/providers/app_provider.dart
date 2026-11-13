import 'package:flutter/material.dart';

import '../models/mahasiswa.dart';
import '../models/note.dart';

// ==========================================
// 1. APP PROVIDER (InheritedWidget)
// ==========================================

class AppProvider extends InheritedWidget {
  final Mahasiswa student;
  final List<Note> notes;

  final void Function(Mahasiswa) updateStudent;
  final void Function(Note) addNote;
  final void Function(String) deleteNote;

  const AppProvider({
    super.key,
    required this.student,
    required this.notes,
    required this.updateStudent,
    required this.addNote,
    required this.deleteNote,
    required super.child,
  });

  // Mengakses AppProvider dari widget turunannya.
  static AppProvider of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<AppProvider>();

    assert(provider != null, 'AppProvider tidak ditemukan!');

    return provider!;
  }

  // Memberitahu widget ketika data berubah.
  @override
  bool updateShouldNotify(AppProvider oldWidget) {
    return student != oldWidget.student || notes != oldWidget.notes;
  }
}

// ==========================================
// 2. APP PROVIDER WRAPPER (StatefulWidget)
// ==========================================

class AppProviderWrapper extends StatefulWidget {
  final Widget child;
  final Mahasiswa initialStudent;

  const AppProviderWrapper({
    super.key,
    required this.child,
    required this.initialStudent,
  });

  @override
  State<AppProviderWrapper> createState() => _AppProviderWrapperState();
}

class _AppProviderWrapperState extends State<AppProviderWrapper> {
  late Mahasiswa _student;

  List<Note> _notes = [];

  @override
  void initState() {
    super.initState();

    // Menginisialisasi data mahasiswa.
    _student = widget.initialStudent;
  }

  // Memperbarui data mahasiswa.
  void _updateStudent(Mahasiswa newStudent) {
    if (newStudent == _student) return;

    setState(() {
      _student = newStudent;
    });
  }

  // Menambahkan catatan baru.
  void _addNote(Note note) {
    setState(() {
      _notes = List.unmodifiable([..._notes, note]);
    });
  }

  void _deleteNote(String id) {
    setState(() {
      _notes = List.unmodifiable(
        _notes.where((note) => note.id != id).toList(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppProvider(
      student: _student,
      notes: _notes,
      updateStudent: _updateStudent,
      addNote: _addNote,
      deleteNote: _deleteNote,
      child: widget.child,
    );
  }
}
