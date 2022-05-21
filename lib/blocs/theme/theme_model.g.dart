// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ThemeModel _$ThemeModelFromJson(Map<String, dynamic> json) {
  return ThemeModel(
    skinTheme: _$enumDecodeNullable(_$SkinThemeEnumMap, json['skinTheme']),
    wheelColor: _$enumDecodeNullable(_$WheelColorEnumMap, json['wheelColor']),
  );
}

Map<String, dynamic> _$ThemeModelToJson(ThemeModel instance) =>
    <String, dynamic>{
      'skinTheme': _$SkinThemeEnumMap[instance.skinTheme],
      'wheelColor': _$WheelColorEnumMap[instance.wheelColor],
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$SkinThemeEnumMap = {
  SkinTheme.retro: 'retro',
  SkinTheme.black: 'black',
  SkinTheme.silver: 'silver',
  SkinTheme.carbonfiber: 'carbonfiber',
};

const _$WheelColorEnumMap = {
  WheelColor.white: 'white',
  WheelColor.black: 'black',
};