import 'package:flutter/material.dart';
import 'package:navbar/RunningPage/music/spotify_service.dart';

class MusicHomePage extends StatefulWidget {
  const MusicHomePage({super.key});

  @override
  _MusicHomePageState createState() => _MusicHomePageState();
}

class _MusicHomePageState extends State<MusicHomePage> {
  final SpotifyService _spotifyService = SpotifyService();
  Future<List<dynamic>>? _trendingSongs;

  @override
  void initState() {
    super.initState();
    _trendingSongs = _spotifyService.fetchTrendingSongs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Trending Songs',
          style: TextStyle(
              color: Color.fromARGB(255, 235, 77, 77),
              fontSize: 35,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _trendingSongs,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final songs = snapshot.data!;
            return Center(
              child: Container(
                color: Colors.redAccent,
                height: 400,
                width: 400,
                padding: const EdgeInsets.all(6.0),
                child: GridView.builder(
                  padding: const EdgeInsets.all(6.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 4.0,
                    mainAxisSpacing: 4.0,
                  ),
                  itemCount: songs.length,
                  itemBuilder: (context, index) {
                    final song = songs[index];
                    return Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Image.network(
                              song['images'][0]['url'],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
