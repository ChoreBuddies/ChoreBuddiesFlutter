// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chore.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Chore _$ChoreFromJson(Map<String, dynamic> json) => Chore(
  json['id'] as String,
  json['name'] as String,
  json['description'] as String,
  json['assignedTo'] as String?,
  DateTime.parse(json['dueDate'] as String),
  $enumDecode(_$StatusEnumMap, json['status']),
  json['room'] as String,
  rewardPointsCount: (json['rewardPointsCount'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$ChoreToJson(Chore instance) => <String, dynamic>{
  'id': instance.id,
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
