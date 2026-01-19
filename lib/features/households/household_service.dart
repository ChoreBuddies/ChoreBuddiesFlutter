import 'dart:convert';

import 'package:chorebuddies_flutter/features/authentication/auth_client.dart';
import 'package:chorebuddies_flutter/features/authentication/models/authentication_result_dto.dart';
import 'package:chorebuddies_flutter/features/households/models/create_household_dto.dart';
import 'package:chorebuddies_flutter/features/households/models/household.dart';
import 'package:chorebuddies_flutter/features/households/models/join_household_dto.dart';
import 'package:flutter/material.dart';

class HouseholdService extends ChangeNotifier {
  final AuthClient _authClient;
  final String _endpoint = '/household';
  HouseholdService({required AuthClient authClient}) : _authClient = authClient;

    Future<Household> getHousehold(int? id) async {
    try {
      final response = await _authClient.get(
        _authClient.uri('$_endpoint/?id=$id'),
      );
      final dynamic json = jsonDecode(response.body);
      return Household.fromJson(json as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Error getting household: $e');
    }
  }
  Future<AuthenticationResultDto> createHousehold(Household household) async {
    try {
      final response = await _authClient.post(
        _authClient.uri('$_endpoint/add'),
        body: jsonEncode(CreateHouseholdDto(household.name, household.description).toJson())
      );
      final dynamic json = jsonDecode(response.body);
      return AuthenticationResultDto.fromJson(json as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Error getting household: $e');
    }
  }
  Future<Household> updateHousehold(Household household) async {
    int id = household.id as int;
    try {
      final response = await _authClient.put(
        _authClient.uri('$_endpoint/update/$id'),
        body: jsonEncode(household.toJson())
      );
      final dynamic json = jsonDecode(response.body);
      return Household.fromJson(json as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Error updating household: $e');
    }
  }

  Future<Household> joinHousehold(String invitationCode) async {
    try {
      final response = await _authClient.put(
        _authClient.uri('$_endpoint/join'),
        body: jsonEncode(JoinHouseholdDto(invitationCode).toJson()),
      );
      final dynamic json = jsonDecode(response.body);
      notifyListeners();
      return Household.fromJson(json as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Error joining household: $e');
    }
  }
}
