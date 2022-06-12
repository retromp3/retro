import 'package:equatable/equatable.dart';

abstract class SongListEvent extends Equatable {
  const SongListEvent();

  @override
  List<Object> get props => [];

  @override
  bool get stringify => super.stringify;
}

class SongListFetched extends SongListEvent {
  final String playlistID;

  const SongListFetched(this.playlistID);
}

class PlayListsFetched extends SongListEvent {}

class SpotifyConnected extends SongListEvent {}

class SongListPreferencesFetched extends SongListEvent {}