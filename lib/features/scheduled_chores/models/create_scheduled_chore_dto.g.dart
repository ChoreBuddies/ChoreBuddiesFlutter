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
  'choreDuration': instance.choreDuration,
  'everyX': instance.everyX,
};

const _$FrequencyEnumMap = {
  Frequency.daily: 0,
  Frequency.weekly: 1,
  Frequency.monthly: 2,
  Frequency.quarterly: 3,
  Frequency.yearly: 4,
};
