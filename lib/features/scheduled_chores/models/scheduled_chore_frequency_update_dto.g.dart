// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scheduled_chore_frequency_update_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScheduledChoreFrequencyUpdateDto _$ScheduledChoreFrequencyUpdateDtoFromJson(
  Map<String, dynamic> json,
) => ScheduledChoreFrequencyUpdateDto(
  (json['id'] as num).toInt(),
  $enumDecode(_$FrequencyEnumMap, json['frequency']),
);

Map<String, dynamic> _$ScheduledChoreFrequencyUpdateDtoToJson(
  ScheduledChoreFrequencyUpdateDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'frequency': _$FrequencyEnumMap[instance.frequency]!,
};

const _$FrequencyEnumMap = {
  Frequency.daily: 'daily',
  Frequency.weekly: 'weekly',
  Frequency.monthly: 'monthly',
  Frequency.quarterly: 'quarterly',
  Frequency.yearly: 'yearly',
};
