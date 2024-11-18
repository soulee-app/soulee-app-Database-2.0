// lib/spotify_api.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class SpotifyApi {
  final String clientId = 'e8e0a184d6854752b7c48b32f78d0d4d';
  final String clientSecret = 'a60fd518c6f247acbd4eed692dc3cfaa';
  String _accessToken =
      'BQDmpoTv_Wp_ye4J4ytmmgVpKzL2BzEX_sQTDRXbsUSU8vV2PhnUrqJlONPR7vk5eBf4tW';

  Future<void> authenticate() async {
    final response = await http.post(
      Uri.parse('https://accounts.spotify.com/api/token'),
      headers: {
        'Authorization':
            'Basic ${base64Encode(utf8.encode('$clientId:$clientSecret'))}',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {'grant_type': 'client_credentials'},
    );

    if (response.statusCode == 200) {
      _accessToken = jsonDecode(response.body)['access_token'];
    } else {
      throw Exception('Failed to authenticate with Spotify API');
    }
  }

  Future<List<dynamic>> searchTracks(String query) async {
    final response = await http.get(
      Uri.parse('https://api.spotify.com/v1/search?q=$query&type=track'),
      headers: {'Authorization': 'Bearer $_accessToken'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['tracks']['items'];
    } else {
      throw Exception('Failed to load tracks');
    }
  }
}
