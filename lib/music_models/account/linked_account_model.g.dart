// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'linked_account_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LinkedAccountModel _$LinkedAccountModelFromJson(Map<String, dynamic> json) =>
    LinkedAccountModel(
      $enumDecodeNullable(_$ConnectToEnumMap, json['connectTo']),
    );

Map<String, dynamic> _$LinkedAccountModelToJson(LinkedAccountModel instance) =>
    <String, dynamic>{
      'connectTo': _$ConnectToEnumMap[instance.connectTo],
    };

const _$ConnectToEnumMap = {
  ConnectTo.spotify: 'spotify',
};
