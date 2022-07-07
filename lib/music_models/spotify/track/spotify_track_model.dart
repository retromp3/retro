import 'package:json_annotation/json_annotation.dart';
import 'package:retro/music_models/spotify/album/spotify_album_model.dart';

part 'spotify_track_model.g.dart';

@JsonSerializable()
class SpotifyTrackModel {
  final String id;
  final String uri;
  final String name;
  final SpotifyAlbumModel album;
  @JsonKey(name: "duration_ms")
  final int duration;

  SpotifyTrackModel({
    this.duration,
    this.album,
    this.id,
    this.name,
    this.uri,
  });

  factory SpotifyTrackModel.fromJson(Map<String, dynamic> json) =>
      _$SpotifyTrackModelFromJson(json);

  @override
  String toString() {
    return 'SpotifyTrackModel{id: $id, name: $name, album: $album}';
  }
}
