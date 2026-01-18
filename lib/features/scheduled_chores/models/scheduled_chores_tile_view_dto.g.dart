// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scheduled_chores_tile_view_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScheduledChoreTileViewDto _$ScheduledChoreTileViewDtoFromJson(
  Map<String, dynamic> json,
) => ScheduledChoreTileViewDto(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  userName: json['userName'] as String?,
  description: json['description'] as String?,
  frequency: $enumDecode(_$FrequencyEnumMap, json['frequency']),
);

Map<String, dynamic> _$ScheduledChoreTileViewDtoToJson(
  ScheduledChoreTileViewDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'userName': instance.userName,
  'description': instance.description,
  'frequency': _$FrequencyEnumMap[instance.frequency]!,
};

const _$FrequencyEnumMap = {
  Frequency.daily: 'daily',
  Frequency.weekly: 'weekly',
  Frequency.monthly: 'monthly',
  Frequency.quarterly: 'quarterly',
  Frequency.yearly: 'yearly',
};
