import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:retro/music_models/apple_music/song/song_info_model.dart';
import 'package:retro/music_models/apple_music/song/song_model.dart';
import 'package:retro/music_models/playback_state/playback_state_model.dart';
import 'package:spotify_sdk/models/player_state.dart';
import 'package:spotify_sdk/spotify_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:retro/resources/resources.dart';

class SpotifyPlayerProvider extends PlayerProvider {
  static String? _redirectUrl = dotenv.env['SPOTIFY_REDIRECT_URL'];
  static String? _clientID = dotenv.env['SPOTIFY_CLIENT_ID'];

  static SpotifyPlayerProvider _instance = SpotifyPlayerProvider._internal();

  SpotifyPlayerProvider._internal();

  factory SpotifyPlayerProvider() => _instance;

  StreamSubscription? _stateSubscription;

  //PlayerState _currentState;

  @override
  void dispose() {
    _stateSubscription?.cancel();
  }

  @override
  Future<SongInfoModel> getNowPlaying() async {
    final PlayerState state = (await SpotifySdk.getPlayerState())!;

    final s = SongInfoModel(
      title: state.track!.name,
      songID: state.track!.uri,
      duration: state.track!.duration.toDouble() / 1000,
      artistName: state.track!.artist.name,
      albumTitle: state.track!.album.name,
      coverArt: Image.memory(
          (await SpotifySdk.getImage(imageUri: state.track!.imageUri))!),
    );
    print(s);
    return s;
  }

  @override
  Future<PlaybackStateModel> getPlaybackState() async {
    final PlayerState state = (await SpotifySdk.getPlayerState())!;
    return state.isPaused
        ? PlaybackStateModel.paused
        : PlaybackStateModel.playing;
  }

  @override
  Future<double> getPlaybackTime() async {
    final PlayerState state = (await SpotifySdk.getPlayerState())!;
    return state.playbackPosition.toDouble() / 1000;
  }

  @override
  Future<void> pause() async {
    await SpotifySdk.pause();
  }

  @override
  Future<void> play() async {
    await SpotifySdk.resume();
  }
  
  @override
  Future<void> toggleShuffle() async {
    await SpotifySdk.toggleShuffle();
  }

  @override
  Future<void> setPlaybackTime(double time) async {
    final int pos = (time * 1000).toInt();
    await SpotifySdk.seekTo(positionedMilliseconds: pos);
  }

  @override
  Future<void> setQueue(
    List<String?> songId, {
    List<SongModel>? songModels,
  }) async {
    await SpotifySdk.play(spotifyUri: songId.first!);
  }

  @override
  Future<bool> connect() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_clientID == "invalid") _clientID = prefs.getString('clientID');
    final bool isConnected = await SpotifySdk.connectToSpotifyRemote(
        clientId: _clientID!, redirectUrl: _redirectUrl!,);
        
    if (isConnected) {
//      _stateSubscription?.cancel();
//      SpotifySdk.subscribePlayerState()
//          .listen((PlayerState state) => _currentState = state);
    }
    return isConnected;
  }

}
