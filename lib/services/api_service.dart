// lib/services/api_service.dart

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.0.11/foreign_connect';

  // Headers with authentication token
  static Future<Map<String, String>> _getHeaders([String? token]) async {
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  // Login
  static Future<Map<String, dynamic>> login(
      String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login.php'),
        headers: await _getHeaders(),
        body: json.encode({
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to login');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Register
  static Future<Map<String, dynamic>> register(
      String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register.php'),
        headers: await _getHeaders(),
        body: json.encode({
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to register');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Validate Token
  static Future<bool> validateToken(String token) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/validate_token.php'),
        headers: await _getHeaders(token),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['valid'] == true;
      }
      return false;
    } catch (e) {
      print('Token validation error: $e');
      return false;
    }
  }

  // Request Password Reset
  static Future<bool> requestPasswordReset(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/forgot_password.php'),
        headers: await _getHeaders(),
        body: json.encode({
          'email': email,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['success'] == true;
      }
      return false;
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Get User Profile
  static Future<Map<String, dynamic>> getUserProfile(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/profile/get_profile.php'),
        headers: await _getHeaders(token),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to get profile');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Update User Profile
  static Future<bool> updateUserProfile(
      String token, Map<String, dynamic> profileData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/profile/update_profile.php'),
        headers: await _getHeaders(token),
        body: json.encode(profileData),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['success'] == true;
      }
      return false;
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Refresh Token
  static Future<Map<String, dynamic>> refreshToken(String oldToken) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/refresh_token.php'),
        headers: await _getHeaders(oldToken),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          return data;
        }
        throw Exception(data['message'] ?? 'Failed to refresh token');
      }
      throw Exception('Failed to refresh token');
    } catch (e) {
      throw Exception('Token refresh error: $e');
    }
  }

  // Check if token is expired
  static bool isTokenExpired(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return true;

      final payload = json.decode(
        utf8.decode(
          base64Url.decode(
            base64Url.normalize(parts[1]),
          ),
        ),
      );

      final exp = DateTime.fromMillisecondsSinceEpoch(payload['exp'] * 1000);
      return DateTime.now().isAfter(exp);
    } catch (e) {
      print('Token expiration check error: $e');
      return true;
    }
  }

  // Logout (clear local storage)
  static Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    } catch (e) {
      throw Exception('Logout error: $e');
    }
  }
}
