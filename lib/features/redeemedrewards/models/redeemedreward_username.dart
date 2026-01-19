import 'package:json_annotation/json_annotation.dart';

part 'redeemedreward_username.g.dart';

@JsonSerializable()
class RedeemedRewardUsername {
  int id;
  int userId;
  String userName;
  String name;
  int pointsSpent;

  RedeemedRewardUsername(
    this.id,
    this.userId,
    this.userName,
    this.name,
    this.pointsSpent
  );

  factory RedeemedRewardUsername.fromJson(Map<String, dynamic> json) => _$RedeemedRewardUsernameFromJson(json);

  Map<String, dynamic> toJson() => _$RedeemedRewardUsernameToJson(this);
}