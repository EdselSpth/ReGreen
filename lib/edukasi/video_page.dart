import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPage extends StatelessWidget {
  const VideoPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Data Dummy YouTube
    final List<Map<String, String>> videos = [
      {
        'title': 'Mengapa Daur Ulang Penting',
        'duration': '05:54',
        'youtubeId': 'M2BtJdgzo-E',
      },
      {
        'title': 'Memilah Sampah di Rumah',
        'duration': '07.17',
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
                  // Memutar video YouTube di dialog
                  showDialog(
                    context: context,
                    builder: (context) {
                      YoutubePlayerController _controller =
                          YoutubePlayerController(
                        initialVideoId: video['youtubeId']!,
                        flags: const YoutubePlayerFlags(
                          autoPlay: true,
                          mute: false,
                        ),
                      );
                      return AlertDialog(
                        content: SizedBox(
                          width: double.infinity,
                          height: 200,
                          child: YoutubePlayer(
                            controller: _controller,
                            showVideoProgressIndicator: true,
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              _controller.pause();
                              Navigator.pop(context);
                            },
                            child: const Text('Tutup'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      // Thumbnail dari YouTube
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
