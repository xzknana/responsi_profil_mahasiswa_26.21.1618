import 'package:flutter/material.dart';

import 'config/app_config.dart';
import 'models/mahasiswa.dart';
import 'providers/app_provider.dart';
import 'screens/home_screen.dart';

/// Titik awal aplikasi Flutter.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AppConfig.load();

  runApp(const MyApp());
}

/// Widget utama aplikasi.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AppProviderWrapper(
      initialStudent: Mahasiswa(
        name: 'Nama Mahasiswa',
        nim: 'NIM Mahasiswa',
        programStudi: 'Teknik Informatika',
        email: 'email@example.com',
      ),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Catatan Mahasiswa',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
          scaffoldBackgroundColor: const Color(0xFFF8F9FC),
          appBarTheme: const AppBarTheme(centerTitle: false, elevation: 0),
          cardTheme: CardThemeData(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          inputDecorationTheme: const InputDecorationTheme(
            border: OutlineInputBorder(),
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            shape: CircleBorder(),
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
