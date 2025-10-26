import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  int id;
  String? firstName;
  String? lastName;
  DateTime dateOfBirth;
  String userName;
  String? email;

  User(
    this.id,
    this.firstName,
    this.lastName,
    this.dateOfBirth,
    this.userName,
    this.email,
  );

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
