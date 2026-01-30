import 'dart:convert';

import 'package:chorebuddies_flutter/core/http_client_extensions.dart';
import 'package:chorebuddies_flutter/features/chores/chore_constants.dart';
import 'package:chorebuddies_flutter/features/chores/models/chore_create.dart';
import 'package:chorebuddies_flutter/features/chores/models/chore_dto.dart';
import 'package:chorebuddies_flutter/features/chores/models/chore_overview.dart';
import 'package:http/http.dart' as http;

class ChoreService {
  final http.Client _httpClient;
  ChoreService({required http.Client httpClient}) : _httpClient = httpClient;

  Future<List<ChoreOverview>> getChores() async {
    try {
      final response = await _httpClient.get(
        _httpClient.uri(ChoreConstants.apiEndpointGetChoreById),
      );
      final List<dynamic> jsonList = jsonDecode(response.body);

      return jsonList
          .map((json) => ChoreOverview.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('error fetching chores: $e');
    }
  }

  Future<List<ChoreOverview>> getHouseholdChores() async {
    try {
      final response = await _httpClient.get(
        _httpClient.uri(ChoreConstants.apiEndpointGetHouseholdChores),
      );
      final List<dynamic> jsonList = jsonDecode(response.body);

      return jsonList
          .map((json) => ChoreOverview.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('error fetching chores: $e');
    }
  }

  Future<List<ChoreOverview>> getUnverifiedChores() async {
    try {
      final response = await _httpClient.get(
        _httpClient.uri(ChoreConstants.apiEndpointGetHouseholdUnverifiedChores),
      );
      final List<dynamic> jsonList = jsonDecode(response.body);

      return jsonList
          .map((json) => ChoreOverview.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('error fetching unverified chores: $e');
    }
  }

  Future<ChoreDto?> getChore(int id) async {
    try {
      final response = await _httpClient.get(
        _httpClient.uri('${ChoreConstants.apiEndpointGetChoreById}/$id'),
      );
      final Map<String, dynamic> jsonChore = jsonDecode(response.body);

      return ChoreDto.fromJson(jsonChore);
    } catch (e) {
      throw Exception('error fetching chore: $e');
    }
  }

  Future<ChoreDto?> createChore(ChoreCreate chore) async {
    try {
      final response = await _httpClient.post(
        _httpClient.uri(ChoreConstants.apiEndpointCreateChore),
        body: jsonEncode(chore),
      );
      final Map<String, dynamic> jsonChore = jsonDecode(response.body);

      return ChoreDto.fromJson(jsonChore);
    } catch (e) {
      throw Exception('error adding chore: $e');
    }
  }

  Future<ChoreDto?> updateChore(ChoreDto chore) async {
    try {
      final response = await _httpClient.post(
        _httpClient.uri(ChoreConstants.apiEndpointUpdateChore),
        body: jsonEncode(chore),
      );
      final Map<String, dynamic> jsonChore = jsonDecode(response.body);

      return ChoreDto.fromJson(jsonChore);
    } catch (e) {
      throw Exception('error updating chore: $e');
    }
  }

  Future<ChoreOverview> markChoreAsDone(int choreId) async {
    try {
      final response = await _httpClient.post(
        _httpClient.uri('${ChoreConstants.apiEndpointMarkChoreAsDone}$choreId'),
      );
      final Map<String, dynamic> jsonChore = jsonDecode(response.body);

      return ChoreOverview.fromJson(jsonChore);
    } catch (e) {
      throw Exception('error marking chore as done: $e');
    }
  }

  Future<ChoreOverview> verifyChore(int choreId) async {
    try {
      final response = await _httpClient.post(
        _httpClient.uri('${ChoreConstants.apiEndpointVerifyChore}$choreId'),
      );
      final Map<String, dynamic> jsonChore = jsonDecode(response.body);

      return ChoreOverview.fromJson(jsonChore);
    } catch (e) {
      throw Exception('error verifying chore: $e');
    }
  }
}
