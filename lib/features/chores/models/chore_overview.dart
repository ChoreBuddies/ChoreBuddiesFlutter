import 'package:chorebuddies_flutter/features/chores/models/status.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chore_overview.g.dart';

@JsonSerializable()
class ChoreOverview {
  int id;
  String name;
  int? assignedTo;
  Status status;
  String room;
  DateTime dueDate;

  ChoreOverview(this.id, this.name, this.assignedTo, this.status, this.room, this.dueDate);

  factory ChoreOverview.fromJson(Map<String, dynamic> json) =>
      _$ChoreOverviewFromJson(json);

  Map<String, dynamic> toJson() => _$ChoreOverviewToJson(this);
}
