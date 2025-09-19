import 'dart:async';
import 'package:chorebuddies_flutter/authentication/auth_manager.dart';
import 'package:http/http.dart' as http;

class AuthClient extends http.BaseClient {
  final http.Client _inner;
  final AuthManager _authManager;
  final String baseUrl;

  Uri uri(String path) => Uri.parse('$baseUrl$path');

  AuthClient({
    required this.baseUrl,
    required AuthManager authManager,
    http.Client? inner,
  }) : _inner = inner ?? http.Client(),
       _authManager = authManager;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final token = _authManager.token;

    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    request.headers['Content-Type'] = 'application/json';
    var response = await _inner.send(request);

    if (response.statusCode == 401) {
      final refreshed = await _authManager.refreshTokens();
      if (refreshed) {
        final newToken = _authManager.token;
        if (newToken != null) {
          request.headers['Authorization'] = 'Bearer $newToken';
          response = await _inner.send(request);
        }
      }
    }
    return response;
  }
}
