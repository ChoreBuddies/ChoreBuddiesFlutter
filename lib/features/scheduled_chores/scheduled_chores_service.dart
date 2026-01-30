import 'dart:convert';

import 'package:chorebuddies_flutter/core/http_client_extensions.dart';
import 'package:chorebuddies_flutter/features/scheduled_chores/models/create_scheduled_chore_dto.dart';
import 'package:chorebuddies_flutter/features/scheduled_chores/models/scheduled_chore_dto.dart';
import 'package:chorebuddies_flutter/features/scheduled_chores/models/scheduled_chore_frequency_update_dto.dart';
import 'package:chorebuddies_flutter/features/scheduled_chores/models/scheduled_chores_tile_view_dto.dart';
import 'package:chorebuddies_flutter/features/scheduled_chores/scheduled_chores_constants.dart';
import 'package:http/http.dart' as http;

import '../predefined_chores/models/predefined_chore_request.dart';

class ScheduledChoresService {
  final http.Client _httpClient;

  ScheduledChoresService({required http.Client httpClient})
    : _httpClient = httpClient;

  Future<ScheduledChoreDto?> getChoreById(int id) async {
    try {
      final response = await _httpClient.get(
        _httpClient.uri(
          '${ScheduledChoresConstants.apiEndpointScheduledChores}/$id',
        ),
      );

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
      final response = await _httpClient.get(
        _httpClient.uri(
          ScheduledChoresConstants.apiEndpointGetHouseholdScheduledChores,
        ),
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
      final response = await _httpClient.get(
        _httpClient.uri(
          ScheduledChoresConstants
              .apiEndpointGetHouseholdScheduledChoresOverview,
        ),
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
      final response = await _httpClient.post(
        _httpClient.uri(
          ScheduledChoresConstants.apiEndpointUpdateScheduledChores,
        ),
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
      final response = await _httpClient.post(
        _httpClient.uri(
          ScheduledChoresConstants.apiEndpointCreateScheduledChores,
        ),
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

  Future<void> addPredefinedChores(PredefinedChoreRequest request) async {
    final response = await _httpClient.post(
      _httpClient.uri(ScheduledChoresConstants.apiEndpointAddPredefined),
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      return;
    }
  }

  Future<ScheduledChoreTileViewDto?> updateChoreFrequency(
    int choreId,
    Frequency frequency,
  ) async {
    try {
      final dto = ScheduledChoreFrequencyUpdateDto(choreId, frequency);

      final response = await _httpClient.put(
        _httpClient.uri(
          ScheduledChoresConstants.apiEndpointUpdateChoreFrequency,
        ),
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
      final response = await _httpClient.delete(
        _httpClient.uri(
          '${ScheduledChoresConstants.apiEndpointScheduledChores}/$choreId',
        ),
      );

      return response.statusCode >= 200 && response.statusCode < 300;
    } catch (e) {
      throw Exception('Error deleting scheduled chore: $e');
    }
  }
}
