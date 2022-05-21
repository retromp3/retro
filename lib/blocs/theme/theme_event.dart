import 'package:equatable/equatable.dart';
import 'package:retro/blocs/theme/theme.dart';

abstract class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object> get props => [];
}

class SkinThemeChanged extends ThemeEvent {
  final SkinTheme skinTheme;

  const SkinThemeChanged(this.skinTheme);

  @override
  List<Object> get props => [skinTheme];

  @override
  bool get stringify => true;
}

class WheelColorChanged extends ThemeEvent {
  final WheelColor wheelColor;

  WheelColorChanged(this.wheelColor);

  @override
  List<Object> get props => [wheelColor];

  @override
  bool get stringify => true;
}

class PreferencesFetched extends ThemeEvent {}
