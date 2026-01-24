import 'package:json_annotation/json_annotation.dart';
part 'update_role_dto.g.dart';

@JsonSerializable()
class UpdatRoleDto {
  final int id;
  final String roleName;

  UpdatRoleDto({required this.id, required this.roleName});

  factory UpdatRoleDto.fromJson(Map<String, dynamic> json) =>
      _$UpdatRoleDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UpdatRoleDtoToJson(this);
}
