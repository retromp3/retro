import 'package:equatable/equatable.dart';

enum SkinTheme {
  black,
  silver,
  beige,
  bay,
  pink,
  orange,
  coral,
  arcPink,
  red3ds,
  catFrap,
  catLatt,
  catMacc,
  catMocha,
  comfy,
  iphGree,
  iphYell,
  nord,
  mint,
  yellow,
  oledBlack,
  teen,
}

enum WheelColor {
  white,
  black,
  blueMetal,
  pink,
  gray,
  coral,
  red3ds,
  catFrap,
  catLatt,
  catMacc,
  catMocha,
  comfy,
  iphGree,
  iphYell,
  nord,
  mint,
  yellow,
  oledBlack,
  teen,
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
