// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reward.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Reward _$RewardFromJson(Map<String, dynamic> json) => Reward(
  (json['id'] as num?)?.toInt(),
  json['name'] as String,
  json['description'] as String,
  (json['householdId'] as num).toInt(),
  (json['cost'] as num).toInt(),
  (json['quantityAvailable'] as num).toInt(),
);

Map<String, dynamic> _$RewardToJson(Reward instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'householdId': instance.householdId,
  'cost': instance.cost,
  'quantityAvailable': instance.quantityAvailable,
};
