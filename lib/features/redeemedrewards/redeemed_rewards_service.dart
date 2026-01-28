import 'dart:convert';

import 'package:chorebuddies_flutter/core/http_client_extensions.dart';
import 'package:chorebuddies_flutter/features/redeemedrewards/models/create_redeemed_reward.dart';
import 'package:chorebuddies_flutter/features/redeemedrewards/models/fulfill_redeemed_reward.dart';
import 'package:chorebuddies_flutter/features/redeemedrewards/models/redeemed_reward.dart';
import 'package:chorebuddies_flutter/features/redeemedrewards/models/redeemedreward_username.dart';
import 'package:chorebuddies_flutter/features/rewards/models/reward_dto.dart';
import 'package:http/http.dart' as http;

class RedeemedRewardService {
  final http.Client _httpClient;
  final String endpoint = '/redeemedRewards';
  RedeemedRewardService({required http.Client httpClient})
    : _httpClient = httpClient;

  Future<List<RedeemedReward>> getUsersRedeemedRewards() async {
    try {
      final response = await _httpClient.get(_httpClient.uri(endpoint));
      final List<dynamic> jsonList = jsonDecode(response.body);

      return jsonList
          .map((json) => RedeemedReward.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('error getting user redeemed rewards: $e');
    }
  }

  Future<RedeemedReward?> redeemReward(Reward reward) async {
    try {
      final response = await _httpClient.post(
        _httpClient.uri('$endpoint/redeem'),
        body: jsonEncode(CreateRedeemedReward(reward.id!, true)),
      );
      if (response.statusCode != 200) {
        return null;
      }
      final Map<String, dynamic> jsonRedeemedReward = jsonDecode(response.body);

      return RedeemedReward.fromJson(jsonRedeemedReward);
    } catch (e) {
      throw Exception('error getting redeeming reward: $e');
    }
  }

  Future<bool> fulfillReward(RedeemedRewardUsername redeemedReward) async {
    try {
      final response = await _httpClient.put(
        _httpClient.uri('$endpoint/fulfill'),
        body: jsonEncode(FulfillRedeemedReward(redeemedReward.id)),
      );
      if (response.statusCode != 200) {
        return false;
      }
      final dynamic jsonResult = jsonDecode(response.body);

      if (jsonResult is bool) {
        return jsonResult;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception('error getting redeeming reward: $e');
    }
  }

  Future<List<RedeemedRewardUsername>>
  getHouseholdUnfulfilledRedeemedRewards() async {
    try {
      final response = await _httpClient.get(
        _httpClient.uri('$endpoint/household/unfulfilled'),
      );
      final List<dynamic> jsonList = jsonDecode(response.body);

      return jsonList
          .map(
            (json) =>
                RedeemedRewardUsername.fromJson(json as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      throw Exception(
        'error getting household unfulfilled redeemed rewards: $e',
      );
    }
  }
}
