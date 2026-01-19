// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'household.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Household _$HouseholdFromJson(Map<String, dynamic> json) => Household(
  (json['id'] as num?)?.toInt(),
  json['name'] as String?,
  json['description'] as String?,
);

Map<String, dynamic> _$HouseholdToJson(Household instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
};
