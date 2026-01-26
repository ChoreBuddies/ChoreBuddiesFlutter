// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chore_overview.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChoreOverview _$ChoreOverviewFromJson(Map<String, dynamic> json) =>
    ChoreOverview(
      (json['id'] as num).toInt(),
      json['name'] as String,
      (json['assignedTo'] as num?)?.toInt(),
      $enumDecodeNullable(_$StatusEnumMap, json['status']) ?? Status.unassigned,
      json['room'] as String,
      DateTime.parse(json['dueDate'] as String),
    );

Map<String, dynamic> _$ChoreOverviewToJson(ChoreOverview instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'assignedTo': instance.assignedTo,
      'status': _$StatusEnumMap[instance.status]!,
      'room': instance.room,
      'dueDate': instance.dueDate.toIso8601String(),
    };

const _$StatusEnumMap = {
  Status.unassigned: 0,
  Status.assigned: 1,
  Status.completed: 2,
  Status.unverifiedcompleted: 3,
};
