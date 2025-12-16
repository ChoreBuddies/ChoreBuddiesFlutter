import 'package:json_annotation/json_annotation.dart';

part 'update_fcmtoken_dto.g.dart';

@JsonSerializable()
class UpdateFcmtokenDto {
  String token;

  UpdateFcmtokenDto(this.token);

  factory UpdateFcmtokenDto.fromJson(Map<String, dynamic> json) =>
      _$UpdateFcmtokenDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateFcmtokenDtoToJson(this);
}
