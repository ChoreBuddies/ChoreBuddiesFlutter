import 'package:chorebuddies_flutter/features/chores/models/status.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chore_dto.g.dart';

@JsonSerializable()
class ChoreDto {
  int id;
  String name;
  String? description;
  int? userId;
  DateTime? dueDate;
  Status status;
  String? room;
  int rewardPointsCount = 0;

  ChoreDto(this.id, this.name, this.description, this.userId, this.status, this.room, this.rewardPointsCount, this.dueDate);

  factory ChoreDto.fromJson(Map<String, dynamic> json) =>
      _$ChoreDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ChoreDtoToJson(this);
}