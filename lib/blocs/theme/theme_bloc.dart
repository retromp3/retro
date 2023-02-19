import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:retro/blocs/theme/theme.dart';
import 'package:retro/blocs/theme/theme_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  static const String _userPreferencesKey = 'userPreferencesTheme';

  ThemeBloc()
      : super(
          ThemeState(
            skinTheme: SkinTheme.black,
            wheelColor: WheelColor.black,
          ),
        );

  Stream<ThemeState> mapEventToState(ThemeEvent event) async* {
    if (event is SkinThemeChanged) {
      yield* _mapSkinThemeChanged(event);
    } else if (event is WheelColorChanged) {
      yield* _mapWheelColorChanged(event);
    } else if (event is PreferencesFetched) {
      yield* _mapPreferencesFetched(event);
    }
  }

  Stream<ThemeState> _mapPreferencesFetched(PreferencesFetched event) async* {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String prefString = prefs.getString(_userPreferencesKey);
    final ThemeModel themeModel =
        ThemeModel.fromJson(jsonDecode(prefString ?? '{}'));
    yield state.copyWith(
      skinTheme: themeModel.skinTheme,
      wheelColor: themeModel.wheelColor,
    );
  }

  Stream<ThemeState> _mapSkinThemeChanged(SkinThemeChanged event) async* {
    yield state.copyWith(skinTheme: event.skinTheme);
    _setPreferences(skinTheme: event.skinTheme);
  }

  Stream<ThemeState> _mapWheelColorChanged(WheelColorChanged event) async* {
    yield state.copyWith(wheelColor: event.wheelColor);
    _setPreferences(wheelColor: event.wheelColor);
  }

  Future<void> _setPreferences({
    SkinTheme skinTheme,
    WheelColor wheelColor,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final ThemeModel themeModel = ThemeModel(
      skinTheme: skinTheme ?? state.skinTheme,
      wheelColor: wheelColor ?? state.wheelColor,
    );
    final String prefString = jsonEncode(themeModel);
    await prefs.setString(_userPreferencesKey, prefString);
  }
}