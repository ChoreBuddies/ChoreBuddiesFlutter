// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chore_create.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChoreCreate _$ChoreCreateFromJson(Map<String, dynamic> json) => ChoreCreate(
  json['name'] as String,
  json['description'] as String,
  (json['assignedTo'] as num?)?.toInt(),
  $enumDecode(_$StatusEnumMap, json['status']),
  json['room'] as String,
  (json['rewardPointsCount'] as num).toInt(),
  DateTime.parse(json['dueDate'] as String),
);

Map<String, dynamic> _$ChoreCreateToJson(ChoreCreate instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'assignedTo': instance.assignedTo,
      'dueDate': instance.dueDate.toIso8601String(),
      'status': _$StatusEnumMap[instance.status]!,
      'room': instance.room,
      'rewardPointsCount': instance.rewardPointsCount,
    };

const _$StatusEnumMap = {
  Status.unassigned: 0,
  Status.assigned: 1,
  Status.completed: 2,
};
