// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'linked_account_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LinkedAccountModel _$LinkedAccountModelFromJson(Map<String, dynamic> json) {
  return LinkedAccountModel(
    _$enumDecodeNullable(_$ConnectToEnumMap, json['connectTo']),
  );
}

Map<String, dynamic> _$LinkedAccountModelToJson(LinkedAccountModel instance) =>
    <String, dynamic>{
      'connectTo': _$ConnectToEnumMap[instance.connectTo],
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

const _$ConnectToEnumMap = {
  ConnectTo.spotify: 'spotify',
};
