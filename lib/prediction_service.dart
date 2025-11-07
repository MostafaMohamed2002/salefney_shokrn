import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'config.dart';

class PredictionService {
  static const String baseUrl = AppConfig.baseUrl;
  final storage = const FlutterSecureStorage();

  Future<String?> getToken() async {
    return await storage.read(key: 'token');
  }

  Future<void> clearToken() async {
    await storage.delete(key: 'token');
  }

  Future<Map<String, dynamic>> makePrediction(Map<String, dynamic> data) async {
    final token = await getToken();
    if (token == null) {
      throw Exception('Not authenticated');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/predict'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to make prediction: ${response.body}');
    }
  }

  Future<List<Map<String, dynamic>>> getPredictionHistory() async {
    final token = await getToken();
    if (token == null) {
      throw Exception('Not authenticated');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/predictions?user_only=true'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to get predictions: ${response.body}');
    }
  }
}
