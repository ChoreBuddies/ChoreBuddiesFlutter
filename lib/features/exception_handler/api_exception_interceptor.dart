import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../../main.dart';

class ApiExceptionInterceptor extends http.BaseClient {
  final http.Client _inner;

  // Decorator
  ApiExceptionInterceptor({http.Client? inner})
      : _inner = inner ?? http.Client();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    try {
      // AuthClient handler
      final streamResponse = await _inner.send(request);

      // If ok we do nothing
      if (streamResponse.statusCode >= 200 && streamResponse.statusCode < 300) {
        return streamResponse;
      }

      final response = await http.Response.fromStream(streamResponse);
      _handleError(response);

      return http.StreamedResponse(
        http.ByteStream.fromBytes(response.bodyBytes),
        response.statusCode,
        request: response.request,
        headers: response.headers,
        isRedirect: response.isRedirect,
        persistentConnection: response.persistentConnection,
        reasonPhrase: response.reasonPhrase,
      );

    } catch (e) {
      _showSnackBar('Connection error', 'Check your internet connection.');
      rethrow;
    }
  }

  void _handleError(http.Response response) {
    String title = "Error";
    String message = "An unexpected error occurred.";

    // Special handling for 401 error
    if (response.statusCode == 401) {
      final isLoginRequest = response.request?.url.path.toLowerCase().contains('login') ?? false;

      if (!isLoginRequest) {
        _showSnackBar("The session has expired", "Log in again.");
        return;
      }
    }

    try {
      if (response.headers['content-type']?.contains('application/json') ?? false) {
        final data = jsonDecode(response.body);

        title = data['title'] ?? title;
        message = data['detail'] ?? data['message'] ?? message;
      } else {
        message = response.body.isNotEmpty
            ? response.body
            : "HTTP error ${response.statusCode}";
      }
    } catch (_) {
      message = "An unexpected error occurred.";
    }

    if (response.statusCode >= 500) {
      title = "Server error";
      message = "Please try again later.";
    }

    _showSnackBar(title, message);
  }

  void _showSnackBar(String title, String message) {
    rootScaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text('$title: $message'),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        showCloseIcon: true,
      ),
    );
  }
}