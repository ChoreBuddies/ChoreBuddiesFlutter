import 'package:json_annotation/json_annotation.dart';

part 'user_overview.g.dart';

@JsonSerializable()
class UserOverview {
  int id;
  String firstName;
  String lastName;

  UserOverview(this.id, this.firstName, this.lastName);

  factory UserOverview.fromJson(Map<String, dynamic> json) =>
      _$UserOverviewFromJson(json);

  Map<String, dynamic> toJson() => _$UserOverviewToJson(this);
}
