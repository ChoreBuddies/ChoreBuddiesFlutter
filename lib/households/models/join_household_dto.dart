import 'package:json_annotation/json_annotation.dart';

part 'join_household_dto.g.dart';

@JsonSerializable()
class JoinHouseholdDto {
  final String invitationCode;

  const JoinHouseholdDto(this.invitationCode);

  factory JoinHouseholdDto.fromJson(Map<String, dynamic> json) =>
      _$JoinHouseholdDtoFromJson(json);
  Map<String, dynamic> toJson() => _$JoinHouseholdDtoToJson(this);
}
