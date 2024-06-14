import 'package:json_annotation/json_annotation.dart';
import 'theme_state.dart';

part 'theme_model.g.dart';

@JsonSerializable()
class ThemeModel {
  final SkinTheme skinTheme;
  final WheelColor wheelColor;

  ThemeModel({SkinTheme? skinTheme, WheelColor? wheelColor})
      : this.skinTheme = skinTheme ?? SkinTheme.black,
        this.wheelColor = wheelColor ?? WheelColor.black;

  Map<String, dynamic> toJson() => _$ThemeModelToJson(this);

  factory ThemeModel.fromJson(Map<String, dynamic> json) =>
      _$ThemeModelFromJson(json);
}
