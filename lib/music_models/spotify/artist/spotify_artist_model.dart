import 'package:json_annotation/json_annotation.dart';

part 'spotify_artist_model.g.dart';

@JsonSerializable()
class SpotifyArtistModel {
  final String name;

  SpotifyArtistModel(this.name);

  factory SpotifyArtistModel.fromJson(Map<String, dynamic> json) =>
      _$SpotifyArtistModelFromJson(json);

  @override
  String toString() {
    return 'SpotifyArtistModel{name: $name}';
  }
}
