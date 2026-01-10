import 'package:chorebuddies_flutter/chores/models/status.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chore_dto.g.dart';

@JsonSerializable()
class ChoreDto {
  int id;
  String name;
  String description;
  int? assignedTo;
  DateTime dueDate;
  Status status;
  String room;
  int rewardPointsCount;

  ChoreDto(this.id, this.name, this.description, this.assignedTo, this.status, this.room, this.rewardPointsCount, this.dueDate);

  factory ChoreDto.fromJson(Map<String, dynamic> json) =>
      _$ChoreDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ChoreDtoToJson(this);
}