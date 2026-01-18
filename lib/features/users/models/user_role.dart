import 'package:json_annotation/json_annotation.dart';

part 'user_role.g.dart';

@JsonSerializable()
class UserRole {
  int id;
  String userName;
  String roleName;

  UserRole(
    this.id,
    this.userName,
    this.roleName,
  );

  factory UserRole.fromJson(Map<String, dynamic> json) => _$UserRoleFromJson(json);

  Map<String, dynamic> toJson() => _$UserRoleToJson(this);
}
