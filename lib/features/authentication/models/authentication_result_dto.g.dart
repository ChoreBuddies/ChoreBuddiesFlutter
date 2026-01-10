// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'authentication_result_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthenticationResultDto _$AuthenticationResultDtoFromJson(
  Map<String, dynamic> json,
) => AuthenticationResultDto(
  accessToken: json['accessToken'] as String,
  refreshToken: json['refreshToken'] as String,
);

Map<String, dynamic> _$AuthenticationResultDtoToJson(
  AuthenticationResultDto instance,
) => <String, dynamic>{
  'accessToken': instance.accessToken,
  'refreshToken': instance.refreshToken,
};
