import 'dart:convert';
import 'package:http/http.dart' as http;

class GoogleBooksApi {
  final String apiKey = 'AIzaSyCGwQYSP8WHSuZgxU2eMXyAGav6P8AD4zQ';

  Future<List<dynamic>> searchBooks(String query) async {
    final response = await http.get(
      Uri.parse('https://www.googleapis.com/books/v1/volumes?q=$query&key=$apiKey'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['items'];
    } else {
      throw Exception('Failed to load books');
    }
  }
}
