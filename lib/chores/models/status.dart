import 'package:json_annotation/json_annotation.dart';

part 'status.g.dart';

@JsonEnum(alwaysCreate: true)
enum Status {
  @JsonValue(0)
  unassigned,

  @JsonValue(1)
  assigned,

  @JsonValue(2)
  completed,
}
