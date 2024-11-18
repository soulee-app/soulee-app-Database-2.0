// reels_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety_flutter3/flutter_swiper_null_safety_flutter3.dart';
import 'package:provider/provider.dart';
import '../providers/video_provider.dart';
import 'video_player_widget.dart';

class ReelsScreen extends StatelessWidget {
  const ReelsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final videos = Provider.of<VideoProvider>(context).videos;

    return Scaffold(
      backgroundColor:
          Colors.black, // Sets the entire screen background to black
      body: Swiper(
        itemCount: videos.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          return Container(
            color: Colors.black, // Ensures the area outside the video is black
            child: Stack(
              children: [
                VideoPlayerWidget(videoUrl: videos[index].url),
                Positioned(
                  bottom: 60,
                  left: 20,
                  child: Text(
                    videos[index].title,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: Column(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.local_florist, // Represents a flower icon
                          color: Colors.red,
                          size: 30,
                        ),
                        onPressed: () {},
                      ),
                      Text('${videos[index].likes}',
                          style: const TextStyle(color: Colors.white)),
                      const SizedBox(height: 10),
                      IconButton(
                        icon: const Icon(Icons.comment, color: Colors.white),
                        onPressed: () {}, // Add functionality
                      ),
                      Text('${videos[index].comments}',
                          style: const TextStyle(color: Colors.white)),
                      const SizedBox(height: 10),
                      IconButton(
                        icon: const Icon(Icons.share, color: Colors.white),
                        onPressed: () {}, // Add functionality
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
