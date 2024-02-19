// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spotify_track_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SpotifyTrackModel _$SpotifyTrackModelFromJson(Map<String, dynamic> json) =>
    SpotifyTrackModel(
      duration: json['duration_ms'] as int?,
      album: json['album'] == null
          ? null
          : SpotifyAlbumModel.fromJson(json['album'] as Map<String, dynamic>),
      id: json['id'] as String?,
      name: json['name'] as String?,
      uri: json['uri'] as String?,
    );

Map<String, dynamic> _$SpotifyTrackModelToJson(SpotifyTrackModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'uri': instance.uri,
      'name': instance.name,
      'album': instance.album,
      'duration_ms': instance.duration,
    };
