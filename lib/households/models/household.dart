import 'package:json_annotation/json_annotation.dart';

part 'household.g.dart';

@JsonSerializable()
class Household {
  int id;
  Household(this.id);
  factory Household.fromJson(Map<String, dynamic> json) =>
      _$HouseholdFromJson(json);
  Map<String, dynamic> toJson() => _$HouseholdToJson(this);
}
