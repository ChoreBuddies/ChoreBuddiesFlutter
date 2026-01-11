import 'package:json_annotation/json_annotation.dart';
part 'register_request_dto.g.dart';

@JsonSerializable()
class RegisterRequestDto {
  final String email;
  final String password;
  final String userName;
  final String firstName;
  final String lastName;
  final DateTime dateOfBirth;

  RegisterRequestDto({
    required this.email,
    required this.password,
    required this.userName,
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
  });
  Map<String, dynamic> toJson() => _$RegisterRequestDtoToJson(this);
}
