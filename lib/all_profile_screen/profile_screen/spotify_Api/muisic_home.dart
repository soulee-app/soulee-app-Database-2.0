// lib/screens/music_home.dart

import 'package:flutter/material.dart';
import 'package:navbar/all_profile_screen/profile_screen/spotify_Api/spotify_api.dart';

class MusicHome extends StatefulWidget {
  final SpotifyApi spotifyApi;

  const MusicHome({super.key, required this.spotifyApi});

  @override
  _MusicHomeState createState() => _MusicHomeState();
}

class _MusicHomeState extends State<MusicHome> {
  List<dynamic> _songs = [];
  bool _isLoading = false;
  String _errorMessage = '';

  void _searchSongs(String query) async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    try {
      await widget.spotifyApi.authenticate();
      final results = await widget.spotifyApi.searchTracks(query);
      setState(() {
        _songs = results;
      });
    } catch (error) {
      setState(() {
        _errorMessage = error.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _selectSong(dynamic song) {
    Navigator.pop(context, song); // Return selected song to FirstSlideScreen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select a Song")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onSubmitted: _searchSongs,
              decoration: const InputDecoration(
                labelText: 'Search Songs',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          if (_isLoading) const CircularProgressIndicator(),
          if (_errorMessage.isNotEmpty)
            Text(_errorMessage, style: const TextStyle(color: Colors.red)),
          Expanded(
            child: ListView.builder(
              itemCount: _songs.length,
              itemBuilder: (context, index) {
                final song = _songs[index];
                return ListTile(
                  leading: Image.network(song['album']['images'][0]['url']),
                  title: Text(song['name']),
                  subtitle: Text(song['artists'][0]['name']),
                  onTap: () => _selectSong(song),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
