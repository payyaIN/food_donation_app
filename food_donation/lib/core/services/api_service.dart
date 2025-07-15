import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class ApiService extends GetxService {
  // Updated base URL configurations for different environments
  // For Android emulator: use 10.0.2.2
  // For iOS simulator: use localhost
  // For physical device: use your computer's IP address
  static const String baseUrl =
      'http://192.168.0.202:3001/api'; // Changed from 192.168.0.19

  final http.Client _client = http.Client();
  String _token = '';

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        if (_token.isNotEmpty) 'Authorization': 'Bearer $_token',
      };

  void setToken(String token) {
    _token = token;
    print('API token set: ${token.isNotEmpty ? "exists" : "empty"}');
  }

  Future<Map<String, dynamic>> get(String endpoint) async {
    try {
      print('GET request to: $baseUrl$endpoint');
      final response = await _client
          .get(
            Uri.parse('$baseUrl$endpoint'),
            headers: _headers,
          )
          .timeout(Duration(seconds: 15)); // Increased timeout

      print('GET response status: ${response.statusCode}');
      return _handleResponse(response);
    } on SocketException catch (e) {
      print('Socket error: $e');
      throw Exception(
          'Cannot connect to server. Please check if the backend is running on port 3001.');
    } on HttpException catch (e) {
      print('HTTP error: $e');
      throw Exception('Server error. Please try again later.');
    } on FormatException catch (e) {
      print('Format error: $e');
      throw Exception('Invalid response format from server.');
    } catch (e) {
      print('GET request error: $e');
      throw Exception('Network error: $e');
    }
  }

  Future<Map<String, dynamic>> post(
      String endpoint, Map<String, dynamic> data) async {
    try {
      print('POST request to: $baseUrl$endpoint');
      print('POST data: $data');

      final response = await _client
          .post(
            Uri.parse('$baseUrl$endpoint'),
            headers: _headers,
            body: json.encode(data),
          )
          .timeout(Duration(seconds: 15)); // Increased timeout

      print('POST response status: ${response.statusCode}');
      return _handleResponse(response);
    } on SocketException catch (e) {
      print('Socket error: $e');
      throw Exception(
          'Cannot connect to server. Please check if the backend is running on port 3001.');
    } on HttpException catch (e) {
      print('HTTP error: $e');
      throw Exception('Server error. Please try again later.');
    } on FormatException catch (e) {
      print('Format error: $e');
      throw Exception('Invalid response format from server.');
    } catch (e) {
      print('POST request error: $e');
      throw Exception('Network error: $e');
    }
  }

  Future<Map<String, dynamic>> put(
      String endpoint, Map<String, dynamic> data) async {
    try {
      print('PUT request to: $baseUrl$endpoint');
      final response = await _client
          .put(
            Uri.parse('$baseUrl$endpoint'),
            headers: _headers,
            body: json.encode(data),
          )
          .timeout(Duration(seconds: 15)); // Increased timeout

      print('PUT response status: ${response.statusCode}');
      return _handleResponse(response);
    } on SocketException catch (e) {
      print('Socket error: $e');
      throw Exception(
          'Cannot connect to server. Please check if the backend is running on port 3001.');
    } on HttpException catch (e) {
      print('HTTP error: $e');
      throw Exception('Server error. Please try again later.');
    } on FormatException catch (e) {
      print('Format error: $e');
      throw Exception('Invalid response format from server.');
    } catch (e) {
      print('PUT request error: $e');
      throw Exception('Network error: $e');
    }
  }

  Future<Map<String, dynamic>> delete(String endpoint) async {
    try {
      print('DELETE request to: $baseUrl$endpoint');
      final response = await _client
          .delete(
            Uri.parse('$baseUrl$endpoint'),
            headers: _headers,
          )
          .timeout(Duration(seconds: 15)); // Increased timeout

      print('DELETE response status: ${response.statusCode}');
      return _handleResponse(response);
    } on SocketException catch (e) {
      print('Socket error: $e');
      throw Exception(
          'Cannot connect to server. Please check if the backend is running on port 3001.');
    } on HttpException catch (e) {
      print('HTTP error: $e');
      throw Exception('Server error. Please try again later.');
    } on FormatException catch (e) {
      print('Format error: $e');
      throw Exception('Invalid response format from server.');
    } catch (e) {
      print('DELETE request error: $e');
      throw Exception('Network error: $e');
    }
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    try {
      print('Response body: ${response.body}');
      final data = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return data;
      } else {
        throw Exception(data['message'] ?? 'Something went wrong');
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Failed to parse response: ${response.body}');
    }
  }

  // Health check method to test connection
  Future<bool> checkConnection() async {
    try {
      await get('/health');
      return true;
    } catch (e) {
      print('Connection check failed: $e');
      return false;
    }
  }

  @override
  void onClose() {
    _client.close();
    super.onClose();
  }
}
