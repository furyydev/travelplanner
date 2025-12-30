import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static Future<Map<String, dynamic>> get(String url,
      {Map<String, String>? headers}) async {
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: headers ?? {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        try {
          return json.decode(response.body) as Map<String, dynamic>;
        } catch (e) {
          throw Exception('Invalid JSON response: ${response.body.substring(0, 200)}');
        }
      } else {
        String errorMessage = 'HTTP ${response.statusCode}';
        try {
          if (response.body.isNotEmpty) {
            final errorBody = json.decode(response.body);
            errorMessage += ': ${errorBody.toString()}';
          }
        } catch (_) {
          errorMessage += ': ${response.body.substring(0, 200)}';
        }
        throw Exception(errorMessage);
      }
    } catch (e) {
      if (e.toString().contains('API Error')) {
        rethrow;
      }
      throw Exception('Network error: $e');
    }
  }

  static Future<List<dynamic>> getList(String url,
      {Map<String, String>? headers}) async {
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: headers ?? {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body) as List<dynamic>;
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}


