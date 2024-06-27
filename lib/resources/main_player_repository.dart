import 'package:retro/music_models/account/linked_account_model.dart';
import 'package:retro/music_models/apple_music/artist/artist_model.dart';
import 'package:retro/music_models/apple_music/song/song_info_model.dart';
import 'package:retro/music_models/playback_state/playback_state_model.dart';
import 'package:retro/music_models/playlist/playlist_model.dart';
import 'package:retro/resources/resources.dart';
import 'package:retro/resources/shared_preferences_provider.dart';
import 'package:retro/resources/spotify/spotify_player_provider.dart';
import 'package:retro/resources/spotify/spotify_song_list_provider.dart';
import 'dart:async';

class MainPlayerRepository implements PlayerRepository {
  static MainPlayerRepository _instance = MainPlayerRepository._internal();

  MainPlayerRepository._internal();

  factory MainPlayerRepository() => _instance;

  PlayerProvider? _currentPlayerProvider;
  SongListProvider? _currentSongListProvider;
  final PreferencesProvider _preferencesProvider = SharedPreferencesProvider();
  ConnectTo? _currentConnectTo;

  @override
  Future<SongInfoModel> getNowPlaying() async {
    return _currentPlayerProvider!.getNowPlaying();
  }

  @override
  void dispose() {
    _disposeCurrentProvider();
    _preferencesProvider.dispose();
  }

  @override
  Future<PlaybackStateModel> getPlaybackState() async {
    return _currentPlayerProvider!.getPlaybackState();
  }

  @override
  Future<double> getPlaybackTime() async {
    return _currentPlayerProvider!.getPlaybackTime();
  }

  @override
  Future<void> pause() async {
    return _currentPlayerProvider!.pause();
  }

  @override
  Future<void> play() async {
    return _currentPlayerProvider!.play();
  }

  @override
  Future<void> toggleShuffle() async {
    return _currentPlayerProvider!.toggleShuffle();
  }
  

  @override
  Future<void> setPlaybackTime(double time) async {
    return _currentPlayerProvider!.setPlaybackTime(time);
  }

  @override
  Future<void> setQueue(String? songId) async {
    return _currentPlayerProvider!.setQueue([songId]);
  }

  @override
  Future<List<ArtistModel>> fetchAllSongs(String? playlistID) async {
    return (_currentSongListProvider?.fetchAllSongs(playlistID) ?? []) as FutureOr<List<ArtistModel>>;
  }

  @override
  Future<List<PlaylistModel>> fetchUsersPlaylist() async {
    return (_currentSongListProvider?.fetchUsersPlaylist() ?? []) as FutureOr<List<PlaylistModel>>;
  }

  @override
  Future<bool> connect(ConnectTo? connectTo) async {
    switch (connectTo) {
      case ConnectTo.spotify:
        {
          await _disposeCurrentProvider();
          return _connectToSpotify();
        }
      default:
        return false;
    }
  }

  Future<bool> _connectToSpotify() async {
    try {
      _currentPlayerProvider = SpotifyPlayerProvider();
      _currentSongListProvider = SpotifySongListProvider();
      _currentConnectTo = ConnectTo.spotify;
      return await _connectCurrentProviders();
    } catch (e) {
      return false;
    }
  }

  Future<bool> _connectCurrentProviders() async {
    final bool isConnected = await _currentPlayerProvider!.connect() &&
        await _currentSongListProvider!.connect();
    if (!isConnected) {
      _disposeCurrentProvider();
    } else {
      _preferencesProvider
          .savePreferences(LinkedAccountModel(_currentConnectTo));
    }
    return isConnected;
  }

  Future<void> _disposeCurrentProvider() async {
    try {
      await _currentPlayerProvider?.pause();
      _currentPlayerProvider?.dispose();
      _currentSongListProvider?.dispose();
    } catch (e) {}
  }

  @override
  Future<bool> connectToPreferences() async {
    try {
      final LinkedAccountModel linkedAccountModel =
          await _preferencesProvider.fetchPreferences();
      return connect(linkedAccountModel.connectTo);
    } catch (e) {
      return false;
    }
  }
}