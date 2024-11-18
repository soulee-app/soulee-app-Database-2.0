// lib/screens/movie_list.dart

import 'package:flutter/material.dart';

class MovieList extends StatelessWidget {
  final List<dynamic> movies;
  final Function(dynamic) onMovieTap; // Callback for movie selection

  const MovieList({super.key, required this.movies, required this.onMovieTap});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: movies.length,
      itemBuilder: (context, index) {
        final movie = movies[index];
        return ListTile(
          leading: Image.network(
            'https://image.tmdb.org/t/p/w92${movie['poster_path']}',
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.broken_image),
          ),
          title: Text(movie['title'] ?? 'No Title Available'),
          subtitle: Text(movie['release_date'] ?? 'No Release Date'),
          trailing: IconButton(
            icon: const Icon(Icons.movie),
            onPressed: () {
              onMovieTap(movie); // Trigger the callback with the selected movie
            },
          ),
          onTap: () {
            onMovieTap(movie); // Trigger the callback with the selected movie
          },
        );
      },
    );
  }
}
