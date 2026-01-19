import 'package:json_annotation/json_annotation.dart';

part 'create_household_dto.g.dart';

@JsonSerializable()
class CreateHouseholdDto {
  String name;
  String description;
  CreateHouseholdDto(this.name, this.description);
  factory CreateHouseholdDto.fromJson(Map<String, dynamic> json) =>
      _$CreateHouseholdDtoFromJson(json);
  Map<String, dynamic> toJson() => _$CreateHouseholdDtoToJson(this);
}
