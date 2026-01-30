import 'dart:convert';

import 'package:chorebuddies_flutter/core/http_client_extensions.dart';
import 'package:chorebuddies_flutter/features/users/models/update_fcmtoken_dto.dart';
import 'package:chorebuddies_flutter/features/users/models/update_role_dto.dart';
import 'package:chorebuddies_flutter/features/users/models/update_user_dto.dart';
import 'package:chorebuddies_flutter/features/users/models/user.dart';
import 'package:chorebuddies_flutter/features/users/user_service_constants.dart';
import 'package:http/http.dart' as http;
import 'package:chorebuddies_flutter/features/users/models/user_role.dart';
import 'package:chorebuddies_flutter/features/users/models/user_minimal_dto.dart';

class UserService {
  final http.Client _httpClient;
  UserService({required http.Client httpClient}) : _httpClient = httpClient;

  Future<User> getMe() async {
    try {
      final response = await _httpClient.get(
        _httpClient.uri(UserServiceConstants.apiEndpointMe),
      );
      final Map<String, dynamic> meJson = jsonDecode(response.body);

      return User.fromJson(meJson);
    } catch (e) {
      throw Exception('Error fetching current user: $e');
    }
  }

  Future<int> getMyPointsCount() async {
    try {
      final response = await _httpClient.get(
        _httpClient.uri(UserServiceConstants.apiEndpointPoints),
      );
      final dynamic pointsJson = jsonDecode(response.body);

      return pointsJson as int;
    } catch (e) {
      throw Exception('Error fetching current user points count: $e');
    }
  }

  Future<List<UserMinimalDto>> getMyHouseholdMembersAsync() async {
    try {
      final response = await _httpClient.get(
        _httpClient.uri(UserServiceConstants.apiEndpointMyHouseholdMembers),
      );
      final List<dynamic> usersJson = jsonDecode(response.body);

      return usersJson
          .map((json) => UserMinimalDto.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Error fetching users from household: $e');
    }
  }

  Future<List<UserRole>> getUsersRolesFromHousehold() async {
    try {
      final response = await _httpClient.get(
        _httpClient.uri(
          '${UserServiceConstants.apiEndpointMyHouseholdMembers}true',
        ),
      );
      final List<dynamic> usersJson = jsonDecode(response.body);

      return usersJson
          .map((json) => UserRole.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Error fetching users with roles from household: $e');
    }
  }

  Future<bool> updateMe(
    id,
    firstName,
    lastName,
    dateOfBirth,
    userName,
    email,
  ) async {
    var updateUserDto = UpdateUserDto(
      id,
      firstName,
      lastName,
      dateOfBirth,
      userName,
      email,
    );
    try {
      final response = await _httpClient.put(
        _httpClient.uri(UserServiceConstants.apiEndpointMe),
        body: jsonEncode(updateUserDto.toJson()),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        return result == true;
      } else {
        throw Exception(
          'Failed to update user: ${response.statusCode} ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Error updating current user: $e');
    }
  }

  Future<bool> updateUserRole(id, roleName) async {
    var dto = UpdatRoleDto(id: id, roleName: roleName);
    try {
      final response = await _httpClient.put(
        _httpClient.uri(UserServiceConstants.apiEndpointRole),
        body: jsonEncode(dto.toJson()),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception(
          'Failed to update user role: ${response.statusCode} ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Error updating current user role: $e');
    }
  }

  Future<bool> updateFcmToken(token) async {
    var updateFcmtokenDto = UpdateFcmtokenDto(token);
    try {
      final response = await _httpClient.put(
        _httpClient.uri(UserServiceConstants.apiEndpointFcmToken),
        body: jsonEncode(updateFcmtokenDto.toJson()),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        return result == true;
      } else {
        throw Exception(
          'Failed to update FCM token: ${response.statusCode} ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Error updating FCM Token: $e');
    }
  }
}
