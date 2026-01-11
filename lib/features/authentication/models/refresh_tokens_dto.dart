import 'package:json_annotation/json_annotation.dart';

part 'refresh_tokens_dto.g.dart';

@JsonSerializable()
class RefreshTokensDto {
  final String accessToken;
  final String refreshToken;

  RefreshTokensDto({required this.accessToken, required this.refreshToken});
  factory RefreshTokensDto.fromJson(Map<String, dynamic> json) =>
      _$RefreshTokensDtoFromJson(json);

  Map<String, dynamic> toJson() => _$RefreshTokensDtoToJson(this);
}
