import 'package:chorebuddies_flutter/chores/models/status.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chore_overview.g.dart';

@JsonSerializable()
class ChoreOverview {
  String id;
  String name;
  String? assignedTo;
  Status status;
  String room;

  ChoreOverview(this.id, this.name, this.assignedTo, this.status, this.room);

  factory ChoreOverview.fromJson(Map<String, dynamic> json) =>
      _$ChoreOverviewFromJson(json);

  Map<String, dynamic> toJson() => _$ChoreOverviewToJson(this);
}
