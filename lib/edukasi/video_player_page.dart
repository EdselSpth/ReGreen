import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayerPage extends StatefulWidget {
  final String youtubeId;
  final String title;
  final String? deskripsi;

  const VideoPlayerPage({
    super.key,
    required this.youtubeId,
    required this.title,
    this.deskripsi,
  });

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late YoutubePlayerController _controller;
  late String currentTitle;

  bool isExpanded = false;

  static const Color primaryGreen = Color(0xFF558B3E);
  static const Color backgroundLight = Color(0xFFE8EDDE);
  static const Color cardColor = Color(0xFFDDE7CC);

  @override
  void initState() {
    super.initState();
    currentTitle = widget.title;
    _controller = YoutubePlayerController(
      initialVideoId: widget.youtubeId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        enableCaption: true,
        forceHD: false,
      ),
    )..setVolume(100);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: primaryGreen,
      ),
      builder: (context, player) {
        return Scaffold(
          backgroundColor: primaryGreen,
          appBar: _controller.value.isFullScreen
              ? null
              : AppBar(
                  backgroundColor: primaryGreen,
                  elevation: 0,
                  title: Text(
                    currentTitle,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
          body: Container(
            decoration: const BoxDecoration(
              color: backgroundLight,
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            ),
            child: ListView(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(30),
                  ),
                  child: player,
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentTitle,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Wrap(
                        spacing: 8,
                        children: const [
                          Chip(label: Text('Lingkungan')),
                          Chip(label: Text('Edukasi')),
                          Chip(label: Text('Sampah')),
                        ],
                      ),
                      const SizedBox(height: 16),

                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.deskripsi?.isNotEmpty == true
                                  ? widget.deskripsi!
                                  : "Tidak ada deskripsi",
                              maxLines: isExpanded ? null : 3,
                              overflow: isExpanded
                                  ? TextOverflow.visible
                                  : TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  isExpanded = !isExpanded;
                                });
                              },
                              child: Text(
                                isExpanded ? 'Tutup' : 'Baca selengkapnya',
                                style: const TextStyle(
                                  color: primaryGreen,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}