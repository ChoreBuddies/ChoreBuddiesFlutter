import 'dart:convert';

import 'package:chorebuddies_flutter/authentication/auth_client.dart';
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
}
