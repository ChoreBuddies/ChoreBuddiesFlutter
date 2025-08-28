import 'package:http/http.dart' as http;
import 'dart:convert';

class HttpUtil {
  final String _baseUrl;
  final String? _token;
  final http.Client _client;

  HttpUtil({required String baseUrl, http.Client? client})
    : _baseUrl = baseUrl,
      _client = client ?? http.Client(),
      _token = getToken();

  // TODO: Replace with actual TokenService method
  static String getToken() {
    return "mockToken";
  }

  Map<String, String> _headers([Map<String, String>? extra]) {
    final headers = {
      'Content-Type': 'application/json',
      if (_token != null) 'Authorization': 'Bearer $_token',
    };
    if (extra != null) headers.addAll(extra);
    return headers;
  }

  Uri _uri(String path, [Map<String, dynamic>? query]) {
    return Uri.parse('$_baseUrl$path').replace(queryParameters: query);
  }

  Future<http.Response> get(
    String path, {
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) {
    return _client.get(_uri(path, query), headers: _headers(headers));
  }

  Future<http.Response> post(
    String path, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) {
    return _client.post(
      _uri(path),
      headers: _headers(headers),
      body: body != null ? jsonEncode(body) : null,
    );
  }

  Future<http.Response> put(
    String path, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) {
    return _client.put(
      _uri(path),
      headers: _headers(headers),
      body: body != null ? jsonEncode(body) : null,
    );
  }

  Future<http.Response> delete(
    String path, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) {
    return _client.delete(
      _uri(path),
      headers: _headers(headers),
      body: body != null ? jsonEncode(body) : null,
    );
  }

  void close() => _client.close();
}
