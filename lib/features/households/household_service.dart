import 'dart:convert';

import 'package:chorebuddies_flutter/core/http_client_extensions.dart';
import 'package:chorebuddies_flutter/features/authentication/auth_manager.dart';
import 'package:chorebuddies_flutter/features/authentication/models/access_token_dto.dart';
import 'package:chorebuddies_flutter/features/authentication/models/authentication_result_dto.dart';
import 'package:chorebuddies_flutter/features/households/household_constants.dart';
import 'package:chorebuddies_flutter/features/households/models/create_household_dto.dart';
import 'package:chorebuddies_flutter/features/households/models/household.dart';
import 'package:chorebuddies_flutter/features/households/models/join_household_dto.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HouseholdService extends ChangeNotifier {
  final http.Client _httpClient;
  final AuthManager _authManager;
  HouseholdService({
    required http.Client httpClient,
    required AuthManager authManager,
  }) : _httpClient = httpClient,
       _authManager = authManager;

  Future<Household> getHousehold(int? id) async {
    try {
      final response = await _httpClient.get(
        _httpClient.uri(
          '${HouseholdConstants.apiEndpointGetHousehold}/?id=$id',
        ),
      );
      final dynamic json = jsonDecode(response.body);
      return Household.fromJson(json as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Error getting household: $e');
    }
  }

  Future<String?> createHousehold(Household household) async {
    try {
      final response = await _httpClient.post(
        _httpClient.uri(HouseholdConstants.apiEndpointCreateHousehold),
        body: jsonEncode(
          CreateHouseholdDto(household.name, household.description).toJson(),
        ),
      );
      final dynamic json = jsonDecode(response.body);
      final dto = AccessTokenDto.fromJson(json);
      _authManager.storeAccessToken(dto.accessToken);
      notifyListeners();

      return _authManager.householdId;
    } catch (e) {
      throw Exception('Error getting household: $e');
    }
  }

  Future<Household> updateHousehold(Household household) async {
    int id = household.id as int;
    try {
      final response = await _httpClient.put(
        _httpClient.uri('${HouseholdConstants.apiEndpointUpdateHousehold}/$id'),
        body: jsonEncode(household.toJson()),
      );
      final dynamic json = jsonDecode(response.body);
      return Household.fromJson(json as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Error updating household: $e');
    }
  }

  Future<String?> joinHousehold(String invitationCode) async {
    try {
      final response = await _httpClient.put(
        _httpClient.uri(HouseholdConstants.apiEndpointJoinHousehold),
        body: jsonEncode(JoinHouseholdDto(invitationCode).toJson()),
      );
      final dynamic json = jsonDecode(response.body);
      final dto = AccessTokenDto.fromJson(json);
      _authManager.storeAccessToken(dto.accessToken);
      notifyListeners();
      return _authManager.householdId;
    } catch (e) {
      throw Exception('Error joining household: $e');
    }
  }
}
