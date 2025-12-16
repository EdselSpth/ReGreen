import 'package:flutter/material.dart';
import 'video_player_page.dart';

class VideoPage extends StatelessWidget {
  const VideoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> videos = [
      {
        'title': 'Mengapa Daur Ulang Penting',
        'duration': '05:54',
        'youtubeId': 'M2BtJdgzo-E',
      },
      {
        'title': 'Memilah Sampah di Rumah',
        'duration': '07:17',
        'youtubeId': 'zfJLbjN-O98',
      },
      {
        'title': 'Bahaya Senyap Mikroplastik',
        'duration': '05:10',
        'youtubeId': 'wDqu0SRjjWE',
      },
      {
        'title': 'Kompos Sampah Makanan di Rumah',
        'duration': '05:09',
        'youtubeId': 'RhEHoyYPtTM',
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
        decoration: const BoxDecoration(
          color: Color(0xFFE8EDDE),
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
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
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => VideoPlayerPage(
                        youtubeId: video['youtubeId']!,
                        title: video['title']!,
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          'https://img.youtube.com/vi/${video['youtubeId']}/0.jpg',
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              video['title']!,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(Icons.access_time, size: 14),
                                const SizedBox(width: 4),
                                Text(video['duration']!),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.play_circle_fill,
                        size: 32,
                        color: Color(0xFF558B3E),
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
