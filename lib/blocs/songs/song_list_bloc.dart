import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:playify/playify.dart';
import 'package:retro/blocs/songs/song_list_event.dart';
import 'package:retro/blocs/songs/song_list_state.dart';
import 'package:retro/music_models/apple_music/artist/artist_model.dart';
import 'package:retro/music_models/playlist/playlist_model.dart';
import 'package:retro/resources/resources.dart';

class SongListBloc extends Bloc<SongListEvent, SongListState> {
  final PlayerRepository _playerRepository;

  SongListBloc(PlayerRepository playerRepository)
      : assert(playerRepository != null),
        this._playerRepository = playerRepository,
        super(SongListNotConnected());

  @override
  Stream<SongListState> mapEventToState(SongListEvent event) async* {
    if (event is SongListFetched) {
      yield* _mapSongListFetched(event);
    } else if (event is PlayListsFetched) {
      yield* _mapPlayListsFetched(event);
    } else if (event is SpotifyConnected) {
      yield* _mapSpotifyConnected(event);
    } else if (event is SongListPreferencesFetched) {
      yield* _mapSongListPreferencesFetched(event);
    }
  }

  Stream<SongListState> _mapSongListFetched(SongListFetched event) async* {
    if (state is SongListFetchSuccess) {
      try {
        final List<ArtistModel> artistList =
            await _playerRepository.fetchAllSongs(event.playlistID);
        yield SongListFetchSuccess(
          artistsList: artistList,
          currentPlaylistID: event.playlistID,
          playlists: (state as SongListFetchSuccess).playlists,
        );
      } catch (e) {
        yield SongListFetchError();
      }
    }
  }

  Stream<SongListState> _mapPlayListsFetched(PlayListsFetched event) async* {
    try {
      final List<PlaylistModel> playLists =
          await _playerRepository.fetchUsersPlaylist();
      final String? currentPlayListId = playLists.isEmpty ? '' : playLists[0].id;
      final List<ArtistModel> artistList =
          await _playerRepository.fetchAllSongs(currentPlayListId);
      yield SongListFetchSuccess(
          playlists: playLists,
          currentPlaylistID: currentPlayListId,
          artistsList: artistList);
    } catch (e) {
      yield SongListFetchError();
    }
  }

  Stream<SongListState> _mapSpotifyConnected(SpotifyConnected event) async* {
    if (!(state is SongListInProgress)) yield* _connectTo(ConnectTo.spotify);
  }

  Stream<SongListState> _connectTo(ConnectTo connectTo) async* {
    yield SongListInProgress();
    try {
      final isConnected = await _playerRepository.connect(connectTo);
      if (isConnected) {
        yield* _mapPlayListsFetched(PlayListsFetched());
      } else {
        yield SongListConnectionError();
      }
    } catch (e) {
      yield SongListConnectionError();
    }
  }

  Stream<SongListState> _mapSongListPreferencesFetched(
      SongListPreferencesFetched event) async* {
    yield SongListInProgress();
    try {
      final isConnected = await _playerRepository.connectToPreferences();
      if (isConnected) {
        yield* _mapPlayListsFetched(PlayListsFetched());
      } else {
        yield SongListNotConnected();
      }
    } catch (e) {
      yield SongListNotConnected();
    }
  }
}