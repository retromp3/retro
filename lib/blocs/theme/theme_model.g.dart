// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ThemeModel _$ThemeModelFromJson(Map<String, dynamic> json) => ThemeModel(
      skinTheme: $enumDecodeNullable(_$SkinThemeEnumMap, json['skinTheme']),
      wheelColor: $enumDecodeNullable(_$WheelColorEnumMap, json['wheelColor']),
    );

Map<String, dynamic> _$ThemeModelToJson(ThemeModel instance) =>
    <String, dynamic>{
      'skinTheme': _$SkinThemeEnumMap[instance.skinTheme]!,
      'wheelColor': _$WheelColorEnumMap[instance.wheelColor]!,
    };

const _$SkinThemeEnumMap = {
  SkinTheme.retro: 'retro',
  SkinTheme.black: 'black',
  SkinTheme.silver: 'silver',
  SkinTheme.carbonfiber: 'carbonfiber',
};

const _$WheelColorEnumMap = {
  WheelColor.white: 'white',
  WheelColor.black: 'black',
  WheelColor.red: 'red',
};