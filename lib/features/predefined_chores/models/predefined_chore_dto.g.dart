// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'predefined_chore_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PredefinedChoreDto _$PredefinedChoreDtoFromJson(Map<String, dynamic> json) =>
    PredefinedChoreDto(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      description: json['description'] as String,
      room: json['room'] as String,
      rewardPointsCount: (json['rewardPointsCount'] as num).toInt(),
      choreDuration: (json['choreDuration'] as num).toInt(),
      frequency: $enumDecode(_$FrequencyEnumMap, json['frequency']),
      everyX: (json['everyX'] as num).toInt(),
    );

Map<String, dynamic> _$PredefinedChoreDtoToJson(PredefinedChoreDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'room': instance.room,
      'rewardPointsCount': instance.rewardPointsCount,
      'choreDuration': instance.choreDuration,
      'frequency': _$FrequencyEnumMap[instance.frequency]!,
      'everyX': instance.everyX,
    };

const _$FrequencyEnumMap = {
  Frequency.daily: 0,
  Frequency.weekly: 1,
  Frequency.monthly: 2,
  Frequency.quarterly: 3,
  Frequency.yearly: 4,
};
