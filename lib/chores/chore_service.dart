import 'dart:convert';

import 'package:chorebuddies_flutter/authentication/auth_client.dart';
import 'package:chorebuddies_flutter/chores/models/chore_create.dart';
import 'package:chorebuddies_flutter/chores/models/chore_dto.dart';
import 'package:chorebuddies_flutter/chores/models/chore_overview.dart';

class ChoreService {
  final AuthClient _authClient;
  final String endpoint = '/chores';
  ChoreService({required AuthClient authClient}) : _authClient = authClient;

  Future<List<ChoreOverview>> getChores() async {
    try {
      final response = await _authClient.get(_authClient.uri(endpoint));
      final List<dynamic> jsonList = jsonDecode(response.body);

      return jsonList
          .map((json) => ChoreOverview.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('error fetching chores: $e');
    }
  }
  Future<ChoreDto?> getChore(int id) async {
    try {
      final response = await _authClient.get(_authClient.uri('$endpoint/$id'));
      final Map<String, dynamic> jsonChore = jsonDecode(response.body);

      return ChoreDto.fromJson(jsonChore);
    } catch (e) {
      throw Exception('error fetching chore: $e');
    }
  }
    Future<ChoreDto?> createChore(ChoreCreate chore) async {
    try {
      final response = await _authClient.post(_authClient.uri('$endpoint/add'),  body: jsonEncode(chore));
      final Map<String, dynamic> jsonChore = jsonDecode(response.body);

      return ChoreDto.fromJson(jsonChore);
    } catch (e) {
      throw Exception('error adding chore: $e');
    }
  }
    Future<ChoreDto?> updateChore(ChoreDto chore) async {
    try {
      final response = await _authClient.post(_authClient.uri('$endpoint/update'),  body: jsonEncode(chore));
      final Map<String, dynamic> jsonChore = jsonDecode(response.body);

      return ChoreDto.fromJson(jsonChore);
    } catch (e) {
      throw Exception('error updating chore: $e');
    }
  }
  Future<ChoreOverview> markChoreAsDone(int choreId) async {
    try {
      final response = await _authClient.post(_authClient.uri('$endpoint/markAsDone?choreId=$choreId'));
      final Map<String, dynamic> jsonChore = jsonDecode(response.body);

      return ChoreOverview.fromJson(jsonChore);
    } catch (e) {
      throw Exception('error marking chore as done: $e');
    }
  }
}
