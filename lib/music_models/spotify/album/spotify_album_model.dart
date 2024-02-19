import 'package:json_annotation/json_annotation.dart';
import 'package:retro/music_models/spotify/artist/spotify_artist_model.dart';
import 'package:retro/music_models/spotify/image/spotify_image_model.dart';

part 'spotify_album_model.g.dart';

@JsonSerializable()
class SpotifyAlbumModel {
  final List<SpotifyArtistModel>? artists;
  final List<SpotifyImageModel>? images;
  final String? name;

  SpotifyAlbumModel(this.artists, this.images, this.name);

  factory SpotifyAlbumModel.fromJson(Map<String, dynamic> json) =>
      _$SpotifyAlbumModelFromJson(json);

  @override
  String toString() {
    return 'SpotifyAlbumModel{artists: $artists, images: $images}';
  }
}
