// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'predefined_reward_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PredefinedRewardDto _$PredefinedRewardDtoFromJson(Map<String, dynamic> json) =>
    PredefinedRewardDto(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      description: json['description'] as String,
      cost: (json['cost'] as num).toInt(),
      quantityAvailable: (json['quantityAvailable'] as num).toInt(),
    );

Map<String, dynamic> _$PredefinedRewardDtoToJson(
  PredefinedRewardDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'cost': instance.cost,
  'quantityAvailable': instance.quantityAvailable,
};
