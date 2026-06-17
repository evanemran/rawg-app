import 'dart:convert';

import '../../app/constants/api_constants.dart';
import 'package:http/http.dart' as http;

class RawgApi {
  Future<Map<String, dynamic>> fetchGames(int page) async {
    final url =
        '${ApiConstants.baseUrl}${ApiConstants.games}?key=${ApiConstants.apiKey}';
    final headers = {'Content-Type': 'application/json'};

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      return jsonDecode(response.body) as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to fetch news: $e');
    }
  }
}