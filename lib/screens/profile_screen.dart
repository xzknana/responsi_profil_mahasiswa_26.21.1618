import 'package:flutter/material.dart';

import 'about_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const Color primaryColor = Color(0xFF2563EB);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text(
          'Profil Mahasiswa',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Profile Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 55,
                    backgroundColor: Color(0xFFDBEAFE),
                    child: Icon(Icons.person, size: 65, color: primaryColor),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Rissa Rizkika',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Mahasiswa S1 Informatika',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDBEAFE),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'NIM: 26.21.1618',
                      style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Informasi Mahasiswa
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Informasi Mahasiswa',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 12),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                children: [
                  ProfileItem(
                    icon: Icons.badge_outlined,
                    title: 'Nama Lengkap',
                    value: 'Rissa Rizkika',
                  ),
                  Divider(height: 24),
                  ProfileItem(
                    icon: Icons.school_outlined,
                    title: 'Program Studi',
                    value: 'S1 Informatika',
                  ),
                  Divider(height: 24),
                  ProfileItem(
                    icon: Icons.email_outlined,
                    title: 'Email',
                    value: 'r.rizkika@students.amikom.ac.id',
                  ),
                  Divider(height: 24),
                  ProfileItem(
                    icon: Icons.location_on_outlined,
                    title: 'Lokasi',
                    value: 'Yogyakarta, Indonesia',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Social Media
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Media Sosial',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 12),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SocialIcon(
                    icon: Icons.camera_alt_outlined,
                    label: 'Instagram',
                  ),
                  SocialIcon(icon: Icons.facebook, label: 'Facebook'),
                  SocialIcon(icon: Icons.language, label: 'Website'),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // About Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AboutScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.info_outline),
                label: const Text(
                  'Tentang Aplikasi',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// Widget informasi mahasiswa
class ProfileItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const ProfileItem({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: const Color(0xFF2563EB), size: 23),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Widget media sosial
class SocialIcon extends StatelessWidget {
  final IconData icon;
  final String label;

  const SocialIcon({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 23,
          backgroundColor: const Color(0xFFDBEAFE),
          child: Icon(icon, color: const Color(0xFF2563EB)),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
