// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spotify_album_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SpotifyAlbumModel _$SpotifyAlbumModelFromJson(Map<String, dynamic> json) =>
    SpotifyAlbumModel(
      (json['artists'] as List<dynamic>?)
          ?.map((e) => SpotifyArtistModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['images'] as List<dynamic>?)
          ?.map((e) => SpotifyImageModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['name'] as String?,
    );

Map<String, dynamic> _$SpotifyAlbumModelToJson(SpotifyAlbumModel instance) =>
    <String, dynamic>{
      'artists': instance.artists,
      'images': instance.images,
      'name': instance.name,
    };
