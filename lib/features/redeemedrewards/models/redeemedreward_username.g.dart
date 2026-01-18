// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'redeemedreward_username.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RedeemedRewardUsername _$RedeemedRewardUsernameFromJson(
  Map<String, dynamic> json,
) => RedeemedRewardUsername(
  (json['id'] as num).toInt(),
  (json['userId'] as num).toInt(),
  json['userName'] as String,
  json['name'] as String,
  (json['pointsSpent'] as num).toInt(),
);

Map<String, dynamic> _$RedeemedRewardUsernameToJson(
  RedeemedRewardUsername instance,
) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'userName': instance.userName,
  'name': instance.name,
  'pointsSpent': instance.pointsSpent,
};
