import 'dart:convert';
import 'package:http/http.dart' as http;

class SpotifyService {
  final String clientId = 'e8e0a184d6854752b7c48b32f78d0d4d';
  final String clientSecret = 'a60fd518c6f247acbd4eed692dc3cfaa';

  Future<String> getAccessToken() async {
    final response = await http.post(
      Uri.parse('https://accounts.spotify.com/api/token'),
      headers: {
        'Authorization':
            'Basic ${base64Encode(utf8.encode('$clientId:$clientSecret'))}',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {'grant_type': 'client_credentials'},
    );
    final responseData = json.decode(response.body);
    return responseData['access_token'];
  }

  Future<List<dynamic>> fetchTrendingSongs() async {
    final accessToken = await getAccessToken();
    final response = await http.get(
      Uri.parse(
          'https://api.spotify.com/v1/browse/new-releases?country=US&limit=16'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );
    final responseData = json.decode(response.body);
    return responseData['albums']['items'];
  }
}
