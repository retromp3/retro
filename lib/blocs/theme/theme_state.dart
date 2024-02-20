import 'package:equatable/equatable.dart';

enum SkinTheme {
  retro,
  black,
  silver,
  carbonfiber,
}

enum WheelColor {
  white,
  black,
  red
}

class ThemeState extends Equatable {
  final SkinTheme? skinTheme;
  final WheelColor? wheelColor;

  const ThemeState({this.skinTheme, this.wheelColor});

  @override
  List<Object?> get props => [skinTheme, wheelColor];

  @override
  bool get stringify => true;

  ThemeState copyWith({
    SkinTheme? skinTheme,
    WheelColor? wheelColor,
  }) {
    return ThemeState(
      skinTheme: skinTheme ?? this.skinTheme,
      wheelColor: wheelColor ?? this.wheelColor,
    );
  }
}
