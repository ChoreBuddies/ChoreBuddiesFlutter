import 'package:chorebuddies_flutter/chores/models/status.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chore.g.dart';

@JsonSerializable()
class Chore {
  String id;
  String name;
  String description;
  String? assignedTo;
  DateTime dueDate;
  Status status;
  String room;
  int rewardPointsCount;

  Chore(
    this.id,
    this.name,
    this.description,
    this.assignedTo,
    this.dueDate,
    this.status,
    this.room, {
    this.rewardPointsCount = 0,
  });
}
