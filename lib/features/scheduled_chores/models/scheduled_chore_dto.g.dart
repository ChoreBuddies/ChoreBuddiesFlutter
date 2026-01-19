// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scheduled_chore_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScheduledChoreDto _$ScheduledChoreDtoFromJson(Map<String, dynamic> json) =>
    ScheduledChoreDto(
      id: (json['id'] as num).toInt(),
      minAge: (json['minAge'] as num).toInt(),
      name: json['name'] as String,
      description: json['description'] as String,
      userId: (json['userId'] as num?)?.toInt(),
      room: json['room'] as String,
      rewardPointsCount: (json['rewardPointsCount'] as num).toInt(),
      householdId: (json['householdId'] as num).toInt(),
      choreDuration: (json['choreDuration'] as num).toInt(),
      frequency: $enumDecode(_$FrequencyEnumMap, json['frequency']),
      lastGenerated: json['lastGenerated'] == null
          ? null
          : DateTime.parse(json['lastGenerated'] as String),
      everyX: (json['everyX'] as num).toInt(),
    );

Map<String, dynamic> _$ScheduledChoreDtoToJson(ScheduledChoreDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'minAge': instance.minAge,
      'name': instance.name,
      'description': instance.description,
      'userId': instance.userId,
      'room': instance.room,
      'rewardPointsCount': instance.rewardPointsCount,
      'householdId': instance.householdId,
      'choreDuration': instance.choreDuration,
      'frequency': _$FrequencyEnumMap[instance.frequency]!,
      'lastGenerated': instance.lastGenerated?.toIso8601String(),
      'everyX': instance.everyX,
    };

const _$FrequencyEnumMap = {
  Frequency.daily: 0,
  Frequency.weekly: 1,
  Frequency.monthly: 2,
  Frequency.quarterly: 3,
  Frequency.yearly: 4,
};
