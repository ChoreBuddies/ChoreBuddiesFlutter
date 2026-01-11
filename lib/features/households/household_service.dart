import 'dart:convert';

import 'package:chorebuddies_flutter/features/authentication/auth_client.dart';
import 'package:chorebuddies_flutter/features/households/models/household.dart';
import 'package:chorebuddies_flutter/features/households/models/join_household_dto.dart';
import 'package:flutter/material.dart';

class HouseholdService extends ChangeNotifier {
  final AuthClient _authClient;
  final String _endpoint = '/household';
  HouseholdService({required AuthClient authClient}) : _authClient = authClient;

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
