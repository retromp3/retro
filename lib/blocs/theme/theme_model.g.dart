// GENERATED CODE - DO NOT MODIFY BY HAND
// Yeah but how is it generated?? I modified it by hand.

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
  SkinTheme.black: 'black',
  SkinTheme.silver: 'silver',
  SkinTheme.beige: 'beige',
};

const _$WheelColorEnumMap = {
  WheelColor.white: 'white',
  WheelColor.black: 'black',
};