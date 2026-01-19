import 'package:chorebuddies_flutter/features/chores/models/status.dart';
import 'package:chorebuddies_flutter/features/scheduled_chores/models/scheduled_chores_tile_view_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chore_view_model.g.dart';

@JsonSerializable()
class ChoreViewModel {
  int? id;
  String name;
  String room;
  String? description;
  int? userId;
  int rewardPointsCount;
  DateTime? dueDate;
  int householdId;
  bool isScheduled;
  int choreDuration;
  int everyX;
  Frequency frequency;
  Status status;

  ChoreViewModel({
    this.id,
    this.name = '',
    this.room = '',
    this.description,
    this.userId,
    this.rewardPointsCount = 0,
    this.dueDate,
    this.householdId = 0,
    this.isScheduled = false,
    this.choreDuration = 1,
    this.everyX = 1,
    this.frequency = Frequency.daily,
    this.status = Status.unassigned,
  });

  factory ChoreViewModel.fromJson(Map<String, dynamic> json) =>
      _$ChoreViewModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChoreViewModelToJson(this);
}
