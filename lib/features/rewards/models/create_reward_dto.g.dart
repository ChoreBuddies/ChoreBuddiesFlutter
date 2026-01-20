// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_reward_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateRewardDto _$CreateRewardDtoFromJson(Map<String, dynamic> json) =>
    CreateRewardDto(
      json['name'] as String,
      json['description'] as String,
      (json['householdId'] as num).toInt(),
      (json['cost'] as num).toInt(),
      (json['quantityAvailable'] as num).toInt(),
    );

Map<String, dynamic> _$CreateRewardDtoToJson(CreateRewardDto instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'householdId': instance.householdId,
      'cost': instance.cost,
      'quantityAvailable': instance.quantityAvailable,
    };
