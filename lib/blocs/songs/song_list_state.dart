import 'package:equatable/equatable.dart';
import 'package:playify/playify.dart';
import 'package:retro/music_models/apple_music/album/album_model.dart';
import 'package:retro/music_models/apple_music/artist/artist_model.dart';
import 'package:retro/music_models/apple_music/song/song_model.dart';
import 'package:retro/music_models/playlist/playlist_model.dart';

abstract class SongListState extends Equatable {
  const SongListState();

  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class SongListInProgress extends SongListState {}

class SongListNotConnected extends SongListState {}

class SongListConnectionError extends SongListState {}

class SongListFetchError extends SongListState {}

class SongListFetchSuccess extends SongListState {
  final List<PlaylistModel> playlists;
  final String currentPlaylistID;
  final List<ArtistModel> artistsList;
  final List<SongModel> songList;
  final List<AlbumModel> albumList;

  SongListFetchSuccess({
    this.artistsList,
    this.playlists,
    this.currentPlaylistID,
  })  : songList = [],
        albumList = [] {
    artistsList?.forEach((ArtistModel artist) {
      artist?.albums?.forEach((AlbumModel album) {
        albumList.add(album);
        songList.addAll(album.songs);
      });
    });
  }

  @override
  List<Object> get props => [
        playlists,
        currentPlaylistID,
        artistsList,
        songList,
        albumList,
      ];
}