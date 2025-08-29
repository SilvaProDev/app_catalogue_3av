import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final storage = GetStorage();

  // Base URL de ton API
  final String baseUrl = 'http://192.168.11.1:8000/api';

  /// GET request
  Future<http.Response> getRequest(String endpoint) async {
    final token = storage.read('token');

    final response = await http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: _buildHeaders(token),
    );

    _handleResponse(response);
    return response;
  }

  /// POST request
  Future<http.Response> postRequest(String endpoint, Map<String, dynamic> body) async {
    final token = storage.read('token');

    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: _buildHeaders(token),
      body: jsonEncode(body),
    );

    _handleResponse(response);
    return response;
  }

  /// PUT request
  Future<http.Response> putRequest(String endpoint, Map<String, dynamic> body) async {
    final token = storage.read('token');

    final response = await http.put(
      Uri.parse('$baseUrl$endpoint'),
      headers: _buildHeaders(token),
      body: jsonEncode(body),
    );

    _handleResponse(response);
    return response;
  }

  /// DELETE request
  Future<http.Response> deleteRequest(String endpoint) async {
    final token = storage.read('token');

    final response = await http.delete(
      Uri.parse('$baseUrl$endpoint'),
      headers: _buildHeaders(token),
    );

    _handleResponse(response);
    return response;
  }

  /// Construire les headers
  Map<String, String> _buildHeaders(String? token) {
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  /// Gérer les réponses globalement
  void _handleResponse(http.Response response) {
    if (response.statusCode == 401) {
      // Token expiré → supprimer et rediriger
      storage.remove('token');
      Get.offAllNamed('/login');
    }
    // tu peux aussi gérer ici les 500, 403, etc.
  }

  /// Vérifier si le token est expiré
  bool isTokenExpired(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return true;

      final payload = json.decode(
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1])))
      );

      final exp = payload['exp'];
      final expiryDate = DateTime.fromMillisecondsSinceEpoch(exp * 1000);

      return DateTime.now().isAfter(expiryDate);
    } catch (e) {
      return true; // En cas d'erreur, considérer le token comme expiré
    }
  }
}
