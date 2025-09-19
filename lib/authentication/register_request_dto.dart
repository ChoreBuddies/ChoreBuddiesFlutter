import 'package:json_annotation/json_annotation.dart';
part 'register_request_dto.g.dart';

@JsonSerializable()
class RegisterRequestDto {
  final String email;
  final String password;
  final String userName;

  RegisterRequestDto({
    required this.email,
    required this.password,
    required this.userName,
  });
  Map<String, dynamic> toJson() => _$RegisterRequestDtoToJson(this);
}
