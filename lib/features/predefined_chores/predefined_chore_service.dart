import 'dart:convert';
import 'package:chorebuddies_flutter/core/http_client_extensions.dart';
import 'package:chorebuddies_flutter/features/predefined_chores/models/predefined_chore_dto.dart';
import 'package:chorebuddies_flutter/features/predefined_chores/predefined_chores_constants.dart';
import 'package:http/http.dart' as http;

class PredefinedChoreService {
  final http.Client _httpClient;

  PredefinedChoreService({required http.Client httpClient})
    : _httpClient = httpClient;

  Future<List<PredefinedChoreDto>> getAllPredefinedChores() async {
    final response = await _httpClient.get(
      _httpClient.uri(PredefinedChoresConstants.apiEndpointGetAll),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => PredefinedChoreDto.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load predefined chores');
    }
  }
}
