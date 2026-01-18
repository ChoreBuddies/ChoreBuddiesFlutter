// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_minimal_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserMinimalDto _$UserMinimalDtoFromJson(Map<String, dynamic> json) =>
    UserMinimalDto(
      id: (json['id'] as num).toInt(),
      userName: json['userName'] as String,
    );

Map<String, dynamic> _$UserMinimalDtoToJson(UserMinimalDto instance) =>
    <String, dynamic>{'id': instance.id, 'userName': instance.userName};
