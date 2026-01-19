import 'dart:convert';

import 'package:chorebuddies_flutter/core/http_client_extensions.dart';
import 'package:chorebuddies_flutter/features/notifications/models/notification_preferences_dto.dart';
import 'package:http/http.dart' as http;

class NotificationPreferencesService {
  final http.Client _httpClient;
  final String _endpoint = '/notifications/preferences';
  NotificationPreferencesService({required http.Client httpClient})
    : _httpClient = httpClient;

  Future<List<NotificationPreferencesDto>> getPreferences() async {
    try {
      final response = await _httpClient.get(_httpClient.uri('$_endpoint/me'));
      final List<dynamic> jsonList = jsonDecode(response.body) as List<dynamic>;

      final List<NotificationPreferencesDto> preferences = jsonList
          .map(
            (v) =>
                NotificationPreferencesDto.fromJson(v as Map<String, dynamic>),
          )
          .toList();

      return preferences;
    } catch (e) {
      throw Exception('Error getting notifications preferences: $e');
    }
  }

  Future<bool> updatePreferences(NotificationPreferencesDto pref) async {
    try {
      final response = await _httpClient.put(
        _httpClient.uri(_endpoint),
        body: jsonEncode(pref.toJson()),
      );
      final bool success =
          response.statusCode >= 200 && response.statusCode < 300;

      return success;
    } catch (e) {
      throw Exception('Error joining household: $e');
    }
  }
}
