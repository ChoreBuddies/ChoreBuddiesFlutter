import 'dart:convert';

import 'package:chorebuddies_flutter/features/authentication/auth_client.dart';
import 'package:chorebuddies_flutter/features/notifications/models/notification_preferences_dto.dart';

class NotificationPreferencesService {
  final AuthClient _authClient;
  final String _endpoint = '/notifications/preferences';
  NotificationPreferencesService({required AuthClient authClient})
    : _authClient = authClient;

  Future<List<NotificationPreferencesDto>> getPreferences() async {
    try {
      final response = await _authClient.get(_authClient.uri('$_endpoint/me'));
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
      final response = await _authClient.put(
        _authClient.uri(_endpoint),
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
