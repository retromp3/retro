import 'package:retro/music_models/account/linked_account_model.dart';
import 'package:retro/music_models/apple_music/artist/artist_model.dart';
import 'package:retro/music_models/apple_music/song/song_info_model.dart';
import 'package:retro/music_models/apple_music/song/song_model.dart';
import 'package:retro/music_models/playback_state/playback_state_model.dart';
import 'package:retro/music_models/playlist/playlist_model.dart';

enum ConnectTo { spotify }

abstract class PlayerRepository {
  Future<SongInfoModel> getNowPlaying();

  Future<PlaybackStateModel> getPlaybackState();

  Future<double> getPlaybackTime();

  Future<void> play();

  Future<void> pause();

  Future<void> toggleShuffle();

  Future<void> setQueue(String? songId);

  Future<void> setPlaybackTime(double time);

  Future<List<ArtistModel>> fetchAllSongs(String? playlistId);

  Future<List<PlaylistModel>> fetchUsersPlaylist();

  Future<bool> connect(ConnectTo connectTo);
  
  Future<bool> connectToPreferences();

  void dispose();
}

abstract class PlayerProvider {
  Future<SongInfoModel> getNowPlaying();

  Future<PlaybackStateModel> getPlaybackState();

  Future<double> getPlaybackTime();

  Future<void> play();

  Future<void> pause();

  Future<void> toggleShuffle();

  Future<void> setQueue(
    List<String?> songId, {
    List<SongModel>? songModels,
  });

  Future<void> setPlaybackTime(double time);

  Future<bool> connect();

  void dispose();
}

abstract class SongListProvider {
  Future<List<ArtistModel>> fetchAllSongs(String? playlistId);

  Future<List<SongModel>> fetchSongsBelow(String songId);

  Future<List<PlaylistModel>> fetchUsersPlaylist();

  Future<bool> connect();

  void dispose();
}

abstract class PreferencesProvider {
  Future<LinkedAccountModel> fetchPreferences();

  Future<void> savePreferences(LinkedAccountModel linkedAccountModel);

  void dispose();
}

String getHumanTime(double value) {
  final int min = value ~/ 60;
  final int sec = (value - min * 60).toInt();

  return '$min:${sec < 10 ? '0' : ''}$sec';
}