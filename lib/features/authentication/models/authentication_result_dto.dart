import 'package:json_annotation/json_annotation.dart';
part 'authentication_result_dto.g.dart';

@JsonSerializable()
class AuthenticationResultDto {
  final String accessToken;
  final String refreshToken;

  AuthenticationResultDto({
    required this.accessToken,
    required this.refreshToken,
  });

  factory AuthenticationResultDto.fromJson(Map<String, dynamic> json) =>
      _$AuthenticationResultDtoFromJson(json);
}
