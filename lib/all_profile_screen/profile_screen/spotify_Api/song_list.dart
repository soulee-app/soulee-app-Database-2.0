import 'package:flutter/material.dart';

class SongList extends StatelessWidget {
  final List<dynamic> songs;

  const SongList({super.key, required this.songs});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: songs.length,
      itemBuilder: (context, index) {
        final song = songs[index];
        return ListTile(
          leading: Image.network(song['album']['images'][0]['url']),
          title: Text(song['name']),
          subtitle: Text(song['artists'][0]['name']),
          trailing: IconButton(
            icon: const Icon(Icons.play_arrow),
            onPressed: () {
              // Play song
            },
          ),
        );
      },
    );
  }
}
