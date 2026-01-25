import 'dart:convert';
import 'package:chorebuddies_flutter/core/http_client_extensions.dart';
import 'package:chorebuddies_flutter/features/predefined_chores/models/predefined_chore_dto.dart';
import 'package:chorebuddies_flutter/features/reminders/models/reminder_dto.dart';
import 'package:http/http.dart' as http;

class RemindersService {
  final http.Client _httpClient;

  final String _endpoint = '/reminders';

  RemindersService({required http.Client httpClient})
    : _httpClient = httpClient;

  Future<bool> setReminder(int choreId, DateTime remindAt) async {
    var reminder = ReminderDto(remindAt: remindAt, choreId: choreId);
    try {
      final response = await _httpClient.post(
        _httpClient.uri(_endpoint),
        body: jsonEncode(reminder.toJson()),
        headers: {'Content-Type': 'application/json'},
      );

      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Error Setting Reminder: $e');
    }
  }
}
