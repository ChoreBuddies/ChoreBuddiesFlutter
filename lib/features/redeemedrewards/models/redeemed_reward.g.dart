// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'redeemed_reward.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RedeemedReward _$RedeemedRewardFromJson(Map<String, dynamic> json) =>
    RedeemedReward(
      (json['id'] as num).toInt(),
      (json['userId'] as num).toInt(),
      json['name'] as String,
      json['description'] as String,
      (json['pointsSpent'] as num).toInt(),
      json['isFulfilled'] as bool,
    );

Map<String, dynamic> _$RedeemedRewardToJson(RedeemedReward instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'name': instance.name,
      'description': instance.description,
      'pointsSpent': instance.pointsSpent,
      'isFulfilled': instance.isFulfilled,
    };
