import 'dart:convert';

import 'package:chorebuddies_flutter/core/http_client_extensions.dart';
import 'package:chorebuddies_flutter/features/authentication/auth_manager.dart';
import 'package:chorebuddies_flutter/features/authentication/models/authentication_result_dto.dart';
import 'package:chorebuddies_flutter/features/households/models/household.dart';
import 'package:chorebuddies_flutter/features/households/models/join_household_dto.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HouseholdService extends ChangeNotifier {
  final http.Client _httpClient;
  final AuthManager _authManager;
  final String _endpoint = '/household';
  HouseholdService({
    required http.Client httpClient,
    required AuthManager authManager,
  }) : _httpClient = httpClient,
       _authManager = authManager;

  Future<Household> getHousehold(int? id) async {
    try {
      final response = await _httpClient.get(
        _httpClient.uri('$_endpoint/?id=$id'),
      );
      final dynamic json = jsonDecode(response.body);
      return Household.fromJson(json as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Error getting household: $e');
    }
  }

  Future<String?> joinHousehold(String invitationCode) async {
    try {
      final response = await _httpClient.put(
        _httpClient.uri('$_endpoint/join'),
        body: jsonEncode(JoinHouseholdDto(invitationCode).toJson()),
      );
      final dynamic json = jsonDecode(response.body);
      final dto = AuthenticationResultDto.fromJson(json);
      _authManager.storeTokens(dto.accessToken, dto.refreshToken);
      notifyListeners();
      return _authManager.householdId;
    } catch (e) {
      throw Exception('Error joining household: $e');
    }
  }
}
