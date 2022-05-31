import 'package:equatable/equatable.dart';
import 'package:playify/playify.dart';

abstract class SongListState extends Equatable {
  const SongListState();

  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class SongListInProgress extends SongListState {}

class SongListFetchError extends SongListState {}

class SongListFetchSuccess extends SongListState {
  final List<Artist> artistsList;
  final List<Song> songs;

  SongListFetchSuccess(this.artistsList) : songs = [] {
    artistsList?.forEach((Artist artist) {
      artist?.albums?.forEach((Album album) {
        songs.addAll(album.songs);
      });
    });
  }

  @override
  List<Object> get props => [artistsList];
}