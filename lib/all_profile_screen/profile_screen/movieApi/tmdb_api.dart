import 'dart:convert';
import 'package:http/http.dart' as http;

class TMDBApi {
  final String apiKey = '120b26b227629797dfa5351c002926a8';

  Future<List<dynamic>> searchMovies(String query) async {
    final response = await http.get(
      Uri.parse('https://api.themoviedb.org/3/search/movie?api_key=$apiKey&query=$query'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['results'];
    } else {
      throw Exception('Failed to load movies');
    }
  }
}
