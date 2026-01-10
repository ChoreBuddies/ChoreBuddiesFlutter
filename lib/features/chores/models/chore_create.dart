import 'package:chorebuddies_flutter/features/chores/models/status.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chore_create.g.dart';

@JsonSerializable()
class ChoreCreate {
  String name;
  String? description;
  int? userId;
  DateTime dueDate;
  Status status;
  String? room;
  int rewardPointsCount;

  ChoreCreate(this.name, this.description, this.userId, this.status, this.room, this.rewardPointsCount, this.dueDate);

  factory ChoreCreate.fromJson(Map<String, dynamic> json) =>
      _$ChoreCreateFromJson(json);

  Map<String, dynamic> toJson() => _$ChoreCreateToJson(this);
}