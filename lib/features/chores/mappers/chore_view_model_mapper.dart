import 'package:chorebuddies_flutter/features/chores/models/chore_create.dart';
import 'package:chorebuddies_flutter/features/chores/models/chore_view_model.dart';
import 'package:chorebuddies_flutter/features/chores/models/status.dart';
import 'package:chorebuddies_flutter/features/scheduled_chores/models/create_scheduled_chore_dto.dart';
import 'package:chorebuddies_flutter/features/chores/models/chore_dto.dart';
import 'package:chorebuddies_flutter/features/scheduled_chores/models/scheduled_chore_dto.dart';

extension ChoreViewModelMapper on ChoreViewModel {
  CreateScheduledChoreDto toCreateScheduledDto() {
    return CreateScheduledChoreDto(
      name: name,
      description: description ?? "",
      userId: userId,
      room: room,
      rewardPointsCount: rewardPointsCount,
      frequency: frequency,
      minAge: null,
      choreDuration: choreDuration,
      everyX: everyX,
    );
  }

  ChoreCreate toCreateDto() {
    return ChoreCreate(
      name,
      description,
      userId,
      userId != null ? Status.assigned : Status.unassigned,
      room,
      rewardPointsCount,
      dueDate ?? DateTime.now(),
    );
  }

  ChoreDto toChoreDto() {
    return ChoreDto(
      id!,
      name,
      description,
      userId,
      status,
      room,
      rewardPointsCount,
      dueDate ?? DateTime.now(),
    );
  }

  ScheduledChoreDto toScheduledDto() {
    return ScheduledChoreDto(
      id: id!,
      name: name,
      description: description ?? "",
      userId: userId,
      room: room,
      rewardPointsCount: rewardPointsCount,
      choreDuration: choreDuration,
      frequency: frequency,
      everyX: everyX,
      lastGenerated: null,
      householdId: householdId,
      minAge: 0,
    );
  }

  static ChoreViewModel fromChoreDto(ChoreDto dto) {
    return ChoreViewModel(
      id: dto.id,
      name: dto.name,
      description: dto.description,
      room: dto.room ?? "",
      userId: dto.userId,
      rewardPointsCount: dto.rewardPointsCount,
      dueDate: dto.dueDate,
      isScheduled: false,
      status: dto.status,
    );
  }

  static ChoreViewModel fromScheduledDto(ScheduledChoreDto dto) {
    return ChoreViewModel(
      id: dto.id,
      name: dto.name,
      description: dto.description,
      room: dto.room,
      userId: dto.userId,
      rewardPointsCount: dto.rewardPointsCount,
      choreDuration: dto.choreDuration,
      everyX: dto.everyX,
      frequency: dto.frequency,
      isScheduled: true,
      householdId: dto.householdId,
      status: Status.unassigned,
    );
  }
}
