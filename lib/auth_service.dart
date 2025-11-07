import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'config.dart';

class AuthService {
  static const String baseUrl = AppConfig.baseUrl;
  final storage = const FlutterSecureStorage();

  Future<String?> getToken() async {
    return await storage.read(key: 'token');
  }

  Future<void> saveToken(String token) async {
    await storage.write(key: 'token', value: token);
  }

  Future<void> clearToken() async {
    await storage.delete(key: 'token');
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await saveToken(data['token']);
      return data;
    } else {
      throw Exception('Failed to login: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> register(
    String username,
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to register: ${response.body}');
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null;
  }

  Future<void> logout() async {
    await clearToken();
  }
}
