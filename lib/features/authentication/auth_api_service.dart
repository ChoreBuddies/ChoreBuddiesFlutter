import 'dart:convert';
import 'package:chorebuddies_flutter/features/authentication/models/refresh_tokens_dto.dart';
import 'package:http/http.dart' as http;
import 'models/authentication_result_dto.dart';
import 'models/login_request_dto.dart';
import 'models/register_request_dto.dart';

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

  Future<AuthenticationResultDto> register(
    String email,
    String password,
    String userName,
    String firstName,
    String lastName,
    DateTime dateOfBirth,
  ) async {
    final request = RegisterRequestDto(
      email: email,
      password: password,
      userName: userName,
      firstName: firstName,
      lastName: lastName,
      dateOfBirth: dateOfBirth,
    );

    try {
      final response = await _httpClient.post(
        Uri.parse('$baseUrl$_endpoint/signup'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );

      final Map<String, dynamic> json = jsonDecode(response.body);
      return AuthenticationResultDto.fromJson(json);
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  Future<AuthenticationResultDto> refreshTokens(
    String refreshToken,
    String accessToken,
  ) async {
    final request = RefreshTokensDto(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );

    try {
      final response = await _httpClient.post(
        Uri.parse('$baseUrl$_endpoint/refresh'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
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
