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
  SkinTheme.bay: 'bay',
  SkinTheme.pink: 'pink',
  SkinTheme.orange: 'orange',
  SkinTheme.coral: 'coral',
  SkinTheme.arcPink: 'arcPink',
  SkinTheme.red3ds: 'red3ds',
  SkinTheme.catFrap: 'catFrap',
  SkinTheme.catLatt: 'catLatt',
  SkinTheme.catMacc: 'catMacc',
  SkinTheme.catMocha: 'catMocha',
  SkinTheme.comfy: 'comfy',
  SkinTheme.iphGree: 'iphGree',
  SkinTheme.iphYell: 'iphYell',
  SkinTheme.nord: 'nord',
  SkinTheme.mint: 'mint',
  SkinTheme.yellow: 'yellow',
  SkinTheme.oledBlack: 'oledBlack',
  SkinTheme.teen: 'teen',
};

const _$WheelColorEnumMap = {
  WheelColor.white: 'white',
  WheelColor.black: 'black',
  WheelColor.blueMetal: 'blueMetal',
  WheelColor.pink: 'pink',
  WheelColor.gray: 'gray',
  WheelColor.coral: 'coral',
  WheelColor.red3ds: 'red3ds',
  WheelColor.catFrap: 'catFrap',
  WheelColor.catLatt: 'catLatt',
  WheelColor.catMacc: 'catMacc',
  WheelColor.catMocha: 'catMocha',
  WheelColor.comfy: 'comfy',
  WheelColor.iphGree: 'iphGree',
  WheelColor.iphYell: 'iphYell',
  WheelColor.nord: 'nord',
  WheelColor.mint: 'mint',
  WheelColor.yellow: 'yellow',
  WheelColor.oledBlack: 'oledBlack',
  WheelColor.teen: 'teen',
};
