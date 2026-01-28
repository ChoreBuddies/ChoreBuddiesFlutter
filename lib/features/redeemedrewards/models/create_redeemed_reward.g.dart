// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_redeemed_reward.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateRedeemedReward _$CreateRedeemedRewardFromJson(
  Map<String, dynamic> json,
) => CreateRedeemedReward(
  (json['rewardId'] as num).toInt(),
  json['isFulfilled'] as bool,
);

Map<String, dynamic> _$CreateRedeemedRewardToJson(
  CreateRedeemedReward instance,
) => <String, dynamic>{
  'rewardId': instance.rewardId,
  'isFulfilled': instance.isFulfilled,
};
