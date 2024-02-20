// for switching between spotify, apple music, etc.

import 'package:retro/resources/resources.dart';
import 'package:json_annotation/json_annotation.dart';

part 'linked_account_model.g.dart';

@JsonSerializable()
class LinkedAccountModel {
  final ConnectTo? connectTo;

  LinkedAccountModel(this.connectTo);

  Map<String, dynamic> toJson() => _$LinkedAccountModelToJson(this);

  factory LinkedAccountModel.fromJson(Map<String, dynamic> json) =>
      _$LinkedAccountModelFromJson(json);
}