// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_scheduled_chore_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateScheduledChoreDto _$CreateScheduledChoreDtoFromJson(
  Map<String, dynamic> json,
) => CreateScheduledChoreDto(
  name: json['name'] as String,
  description: json['description'] as String,
  userId: (json['userId'] as num?)?.toInt(),
  room: json['room'] as String,
  rewardPointsCount: (json['rewardPointsCount'] as num).toInt(),
  frequency: $enumDecode(_$FrequencyEnumMap, json['frequency']),
  minAge: (json['minAge'] as num?)?.toInt(),
  choreDuration: (json['choreDuration'] as num).toInt(),
  everyX: (json['everyX'] as num).toInt(),
);

Map<String, dynamic> _$CreateScheduledChoreDtoToJson(
  CreateScheduledChoreDto instance,
) => <String, dynamic>{
  'name': instance.name,
  'description': instance.description,
  'userId': instance.userId,
  'room': instance.room,
  'rewardPointsCount': instance.rewardPointsCount,
  'frequency': _$FrequencyEnumMap[instance.frequency]!,
  'minAge': instance.minAge,
  'choreDuration': instance.choreDuration,
  'everyX': instance.everyX,
};

const _$FrequencyEnumMap = {
  Frequency.daily: 'daily',
  Frequency.weekly: 'weekly',
  Frequency.monthly: 'monthly',
  Frequency.quarterly: 'quarterly',
  Frequency.yearly: 'yearly',
};
