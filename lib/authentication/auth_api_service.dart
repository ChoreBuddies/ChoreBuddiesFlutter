import 'dart:convert';
import 'package:http/http.dart' as http;
import 'authentication_result_dto.dart';
import 'login_request_dto.dart';
import 'register_request_dto.dart';

class AuthApiService {
  final http.Client _httpClient;
  final String baseUrl;
  final String _endpoint = '/auth';

  AuthApiService({required this.baseUrl, http.Client? httpClient})
    : _httpClient = httpClient ?? http.Client();

  Future<AuthenticationResultDto> login(String email, String password) async {
    final request = LoginRequestDto(email: email, password: password);

    try {
      final response = await _httpClient.post(
        Uri.parse('$baseUrl$_endpoint/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode != 200) {
        throw Exception('Login failed: ${response.statusCode}');
      }

      final Map<String, dynamic> meJson = jsonDecode(response.body);
      return AuthenticationResultDto.fromJson(meJson);
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  Future<bool> register(String email, String password, String userName) async {
    final request = RegisterRequestDto(
      email: email,
      password: password,
      userName: userName,
    );

    try {
      final response = await _httpClient.post(
        Uri.parse('$baseUrl$_endpoint/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  Future<AuthenticationResultDto> refreshTokens(String refreshToken) async {
    final request = {'refreshToken': refreshToken};

    try {
      final response = await _httpClient.post(
        Uri.parse('$baseUrl$_endpoint/refresh'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request),
      );

      if (response.statusCode != 200) {
        throw Exception('Refreshing token failed: ${response.statusCode}');
      }

      final Map<String, dynamic> meJson = jsonDecode(response.body);
      return AuthenticationResultDto.fromJson(meJson);
    } catch (e) {
      throw Exception('Refreshing token failed: $e');
    }
  }
}
