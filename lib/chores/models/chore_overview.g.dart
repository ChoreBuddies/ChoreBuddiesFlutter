// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chore_overview.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChoreOverview _$ChoreOverviewFromJson(Map<String, dynamic> json) =>
    ChoreOverview(
      json['id'] as String,
      json['name'] as String,
      json['assignedTo'] as String?,
      $enumDecode(_$StatusEnumMap, json['status']),
      json['room'] as String,
    );

Map<String, dynamic> _$ChoreOverviewToJson(ChoreOverview instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'assignedTo': instance.assignedTo,
      'status': _$StatusEnumMap[instance.status]!,
      'room': instance.room,
    };

const _$StatusEnumMap = {
  Status.unassigned: 0,
  Status.assigned: 1,
  Status.completed: 2,
};
