import 'package:flutter/material.dart';
import 'package:regreen/edukasi/artikel_page.dart';
import 'package:regreen/edukasi/video_page.dart';

class EdukasiScreen extends StatelessWidget {
  const EdukasiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF558B3E), // Warna Hijau Header
      appBar: AppBar(
        backgroundColor: const Color(0xFF558B3E),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Edukasi',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xFFE8EDDE),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Belajar Daur Ulang',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3B5B4F),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Pilih jenis materi yang ingin kamu pelajari — artikel atau video singkat.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 30),

              // Tombol Artikel
              _buildMenuCard(
                icon: Icons.article_rounded,
                title: 'Artikel Edukasi Daur Ulang',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ArtikelPage(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),

              // Tombol Video
              _buildMenuCard(
                icon: Icons.play_circle_fill_rounded,
                title: 'Video Edukasi Singkat',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const VideoPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
        decoration: BoxDecoration(
          color: const Color(0xFFDDE7CC), // Warna kartu
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Color(0xFF558B3E), // Warna ikon bulat
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
