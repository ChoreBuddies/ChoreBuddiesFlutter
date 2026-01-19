// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scheduled_chore_overview_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScheduledChoreOverviewDto _$ScheduledChoreOverviewDtoFromJson(
  Map<String, dynamic> json,
) => ScheduledChoreOverviewDto(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  userId: (json['userId'] as num?)?.toInt(),
  room: json['room'] as String,
);

Map<String, dynamic> _$ScheduledChoreOverviewDtoToJson(
  ScheduledChoreOverviewDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'userId': instance.userId,
  'room': instance.room,
};
