import 'dart:convert';

import 'package:chorebuddies_flutter/authentication/auth_client.dart';
import 'package:chorebuddies_flutter/users/models/update_user_dto.dart';
import 'package:chorebuddies_flutter/users/models/user.dart';

class UserService {
  final AuthClient _authClient;
  final String endpoint = '/users';
  UserService({required AuthClient authClient}) : _authClient = authClient;

  Future<User> getMe() async {
    try {
      final response = await _authClient.get(_authClient.uri('$endpoint/me'));
      final Map<String, dynamic> meJson = jsonDecode(response.body);

      return User.fromJson(meJson);
    } catch (e) {
      throw Exception('Error fetching current user: $e');
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
      final response = await _authClient.put(
        _authClient.uri('$endpoint/me'),
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
}
