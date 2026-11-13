import 'package:flutter/material.dart';

import 'models/mahasiswa.dart';
import 'models/note.dart';
import 'providers/app_provider.dart';
import 'screens/note_form_screen.dart';

void main() {
  runApp(
    AppProviderWrapper(
      initialStudent: Mahasiswa(
        name: 'Rissa Rizkika',
        nim: '26.21.1618',
        programStudi: 'S1 Informatika',
        email: 'advan@example.com',
      ),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Responsi Profil Mahasiswa',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

// Halaman utama untuk menampilkan data dari AppProvider.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = AppProvider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Mahasiswa'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              provider.student.name,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text('NIM: ${provider.student.nim}'),
            Text('Program Studi: ${provider.student.programStudi}'),
            Text('Email: ${provider.student.email}'),

            const Divider(height: 32),

            const Text(
              'Catatan Saya',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            Expanded(
              child: provider.notes.isEmpty
                  ? const Center(child: Text('Belum ada catatan.'))
                  : ListView.builder(
                      itemCount: provider.notes.length,
                      itemBuilder: (context, index) {
                        final note = provider.notes[index];

                        return Card(
                          child: ListTile(
                            title: Text(note.title),
                            subtitle: Text(note.content),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                provider.deleteNote(note.id);
                              },
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NoteFormScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
