import 'dart:convert';

import 'package:chorebuddies_flutter/core/http_client_extensions.dart';
import 'package:chorebuddies_flutter/features/chores/models/chore_create.dart';
import 'package:chorebuddies_flutter/features/chores/models/chore_dto.dart';
import 'package:chorebuddies_flutter/features/chores/models/chore_overview.dart';
import 'package:http/http.dart' as http;

class ChoreService {
  final http.Client _httpClient;
  final String endpoint = '/chores';
  ChoreService({required http.Client httpClient}) : _httpClient = httpClient;

  Future<List<ChoreOverview>> getChores() async {
    try {
      final response = await _httpClient.get(_httpClient.uri(endpoint));
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
      final response = await _httpClient.get(_httpClient.uri('$endpoint/householdChores/unverified'));
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
      final response = await _httpClient.get(_httpClient.uri('$endpoint/$id'));
      final Map<String, dynamic> jsonChore = jsonDecode(response.body);

      return ChoreDto.fromJson(jsonChore);
    } catch (e) {
      throw Exception('error fetching chore: $e');
    }
  }
    Future<ChoreDto?> createChore(ChoreCreate chore) async {
    try {
      final response = await _httpClient.post(_httpClient.uri('$endpoint/add'),  body: jsonEncode(chore));
      final Map<String, dynamic> jsonChore = jsonDecode(response.body);

      return ChoreDto.fromJson(jsonChore);
    } catch (e) {
      throw Exception('error adding chore: $e');
    }
  }
    Future<ChoreDto?> updateChore(ChoreDto chore) async {
    try {
      final response = await _httpClient.post(_httpClient.uri('$endpoint/update'),  body: jsonEncode(chore));
      final Map<String, dynamic> jsonChore = jsonDecode(response.body);

      return ChoreDto.fromJson(jsonChore);
    } catch (e) {
      throw Exception('error updating chore: $e');
    }
  }
  Future<ChoreOverview> markChoreAsDone(int choreId) async {
    try {
      final response = await _httpClient.post(_httpClient.uri('$endpoint/markAsDone?choreId=$choreId'));
      final Map<String, dynamic> jsonChore = jsonDecode(response.body);

      return ChoreOverview.fromJson(jsonChore);
    } catch (e) {
      throw Exception('error marking chore as done: $e');
    }
  }
  Future<ChoreOverview> verifyChore(int choreId) async {
    try {
      final response = await _httpClient.post(_httpClient.uri('$endpoint/verify?choreId=$choreId'));
      final Map<String, dynamic> jsonChore = jsonDecode(response.body);

      return ChoreOverview.fromJson(jsonChore);
    } catch (e) {
      throw Exception('error verifying chore: $e');
    }
  }
}
