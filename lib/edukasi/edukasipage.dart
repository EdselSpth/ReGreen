import 'package:flutter/material.dart';

class EdukasiDaurUlangPage extends StatelessWidget {
  const EdukasiDaurUlangPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9EDDD),
      appBar: AppBar(
        backgroundColor: const Color(0xFF558B3E),
        elevation: 0,
        title: const Text(
          'Edukasi Daur Ulang',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),

            // Header
            Text(
              'Belajar Daur Ulang',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF3B7C87),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Pilih jenis materi yang ingin kamu pelajari — artikel atau video singkat.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 30),

            // Kartu Artikel
            GestureDetector(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFD8DDCD),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: const [
                    Icon(
                      Icons.article_rounded,
                      size: 50,
                      color: Color(0xFF3B7C87),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        'Artikel Edukasi Daur Ulang',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Kartu Video
            GestureDetector(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFD8DDCD),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: const [
                    Icon(
                      Icons.play_circle_fill_rounded,
                      size: 50,
                      color: Color(0xFF5C8D4C),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        'Video Edukasi Singkat',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
