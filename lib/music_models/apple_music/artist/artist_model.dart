import 'package:retro/music_models/apple_music/album/album_model.dart';

class ArtistModel {
  final String? name;
  final List<AlbumModel> albums;

  ArtistModel({this.name, List<AlbumModel>? albums})
      : this.albums = albums ?? [];
}