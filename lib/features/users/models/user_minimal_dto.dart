import 'package:json_annotation/json_annotation.dart';

part 'user_minimal_dto.g.dart';

@JsonSerializable()
class UserMinimalDto {
  final int id;
  final String userName;

  UserMinimalDto({required this.id, required this.userName});

  factory UserMinimalDto.fromJson(Map<String, dynamic> json) =>
      _$UserMinimalDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UserMinimalDtoToJson(this);
}
