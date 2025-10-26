import 'package:json_annotation/json_annotation.dart';

part 'update_user_dto.g.dart';

@JsonSerializable()
class UpdateUserDto {
  int id;
  String firstName;
  String lastName;
  DateTime dateOfBirth;
  String userName;
  String? email;

  UpdateUserDto(
    this.id,
    this.firstName,
    this.lastName,
    this.dateOfBirth,
    this.userName,
    this.email,
  );

  factory UpdateUserDto.fromJson(Map<String, dynamic> json) =>
      _$UpdateUserDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateUserDtoToJson(this);
}
