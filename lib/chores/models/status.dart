import 'package:json_annotation/json_annotation.dart';

part 'status.g.dart';

@JsonEnum(alwaysCreate: true)
enum Status { unassigned, assigned, completed }
