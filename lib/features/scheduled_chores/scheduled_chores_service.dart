import 'dart:convert';

import 'package:chorebuddies_flutter/features/authentication/auth_client.dart';
import 'package:chorebuddies_flutter/features/scheduled_chores/models/create_scheduled_chore_dto.dart';
import 'package:chorebuddies_flutter/features/scheduled_chores/models/scheduled_chore_dto.dart';
import 'package:chorebuddies_flutter/features/scheduled_chores/models/scheduled_chore_frequency_update_dto.dart';
import 'package:chorebuddies_flutter/features/scheduled_chores/models/scheduled_chores_tile_view_dto.dart';

class ScheduledChoresService {
  final AuthClient _authClient;

  final String _endpoint = '/scheduledChores';

  ScheduledChoresService({required AuthClient authClient})
    : _authClient = authClient;

  Future<ScheduledChoreDto?> getChoreById(int id) async {
    try {
      final response = await _authClient.get(_authClient.uri('$_endpoint/$id'));

      if (response.statusCode < 200 || response.statusCode >= 300) {
        return null;
      }

      final Map<String, dynamic> json =
          jsonDecode(response.body) as Map<String, dynamic>;

      return ScheduledChoreDto.fromJson(json);
    } catch (e) {
      throw Exception('Error getting scheduled chore: $e');
    }
  }

  Future<List<ScheduledChoreDto>> getMyHouseholdChores() async {
    try {
      final response = await _authClient.get(
        _authClient.uri('$_endpoint/Household-chores'),
      );

      if (response.statusCode < 200 || response.statusCode >= 300) {
        return [];
      }

      final List<dynamic> jsonList = jsonDecode(response.body) as List<dynamic>;

      return jsonList
          .map((v) => ScheduledChoreDto.fromJson(v as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Error getting household chores: $e');
    }
  }

  Future<List<ScheduledChoreTileViewDto>> getMyHouseholdChoresOverview() async {
    try {
      final response = await _authClient.get(
        _authClient.uri('$_endpoint/household-chores/overview'),
      );

      if (response.statusCode < 200 || response.statusCode >= 300) {
        return [];
      }

      final List<dynamic> jsonList = jsonDecode(response.body) as List<dynamic>;

      return jsonList
          .map(
            (v) =>
                ScheduledChoreTileViewDto.fromJson(v as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      throw Exception('Error getting chores overview: $e');
    }
  }

  Future<ScheduledChoreDto?> updateChore(ScheduledChoreDto chore) async {
    try {
      final response = await _authClient.post(
        _authClient.uri('$_endpoint/update'),
        body: jsonEncode(chore.toJson()),
      );

      if (response.statusCode < 200 || response.statusCode >= 300) {
        return null;
      }

      final Map<String, dynamic> json =
          jsonDecode(response.body) as Map<String, dynamic>;

      return ScheduledChoreDto.fromJson(json);
    } catch (e) {
      throw Exception('Error updating scheduled chore: $e');
    }
  }

  Future<ScheduledChoreDto?> createChore(CreateScheduledChoreDto chore) async {
    try {
      final response = await _authClient.post(
        _authClient.uri('$_endpoint/add'),
        body: jsonEncode(chore.toJson()),
      );

      if (response.statusCode < 200 || response.statusCode >= 300) {
        return null;
      }

      final Map<String, dynamic> json =
          jsonDecode(response.body) as Map<String, dynamic>;

      return ScheduledChoreDto.fromJson(json);
    } catch (e) {
      throw Exception('Error creating scheduled chore: $e');
    }
  }

  Future<ScheduledChoreTileViewDto?> updateChoreFrequency(
    int choreId,
    Frequency frequency,
  ) async {
    try {
      final dto = ScheduledChoreFrequencyUpdateDto(choreId, frequency);

      final response = await _authClient.put(
        _authClient.uri('$_endpoint/frequency'),
        body: jsonEncode(dto.toJson()),
      );

      if (response.statusCode < 200 || response.statusCode >= 300) {
        return null;
      }

      final Map<String, dynamic> json =
          jsonDecode(response.body) as Map<String, dynamic>;

      return ScheduledChoreTileViewDto.fromJson(json);
    } catch (e) {
      throw Exception('Error updating chore frequency: $e');
    }
  }

  Future<bool> deleteChore(int choreId) async {
    try {
      final response = await _authClient.delete(
        _authClient.uri('$_endpoint/$choreId'),
      );

      return response.statusCode >= 200 && response.statusCode < 300;
    } catch (e) {
      throw Exception('Error deleting scheduled chore: $e');
    }
  }
}
