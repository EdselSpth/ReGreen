import 'package:flutter/material.dart';

class VideoPage extends StatelessWidget {
  const VideoPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Data Dummy
    final List<Map<String, String>> videos = [
      {
        'title': 'Cara Memilah Sampah Organik & Anorganik',
        'duration': '05:20',
        'image': 'Assets/onboarding/ob1-image.png', // Pakai aset yang ada dulu
      },
      {
        'title': 'DIY: Membuat Pot Bunga dari Botol Plastik',
        'duration': '03:45',
        'image': 'Assets/onboarding/ob2-image.png',
      },
      {
        'title': 'Mengenal Jenis Plastik yang Bisa Daur Ulang',
        'duration': '08:10',
        'image': 'Assets/onboarding/ob3-image.png',
      },
      {
        'title': 'Tutorial Membuat Kompos Sederhana di Rumah',
        'duration': '06:30',
        'image': 'Assets/onboarding/ob1-image.png',
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF558B3E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF558B3E),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Video Edukasi',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xFFE8EDDE),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: videos.length,
          itemBuilder: (context, index) {
            final video = videos[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: const Color(0xFFDDE7CC),
              elevation: 2,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  // Aksi ketika video diklik
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Memutar: ${video['title']}")),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      // Thumbnail
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          video['image']!,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 14),
                      // Detail Video
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              video['title']!,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(
                                  Icons.access_time_filled,
                                  size: 14,
                                  color: Color(0xFF558B3E),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  video['duration']!,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF558B3E),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Icon Play
                      const Icon(
                        Icons.play_circle_fill,
                        color: Color(0xFF558B3E),
                        size: 32,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
