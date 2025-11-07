import 'dart:convert';

import 'package:http/http.dart' as http;

class PredictionService {
  // Replace with your actual API endpoint
  static const String baseUrl =
      'https://opulent-potato-wprj99q995j39qxw-5000.app.github.dev';

  Future<Map<String, dynamic>> predict(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/predict'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to get prediction: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error making prediction: $e');
    }
  }
}
