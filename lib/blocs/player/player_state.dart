import 'package:equatable/equatable.dart';
import 'package:retro/music_models/apple_music/song/song_info_model.dart';
import 'package:retro/music_models/playback_state/playback_state_model.dart';

abstract class PlayerState extends Equatable {
  final String? lastSongID;

  const PlayerState({required this.lastSongID});

  @override
  List<Object?> get props => [lastSongID];

  @override
  bool get stringify => true;
}

class PlayerUnknownState extends PlayerState {
  const PlayerUnknownState() : super(lastSongID: 'unknown');
}

class NowPlayingState extends PlayerState {
  final SongInfoModel? songInfo;
  final double? playBackTime;
  final PlaybackStateModel? playbackState;

  const NowPlayingState({
    this.songInfo,
    this.playBackTime,
    this.playbackState,
    String? lastSongID,
  }) : super(lastSongID: lastSongID);

  @override
  List<Object?> get props => [
        songInfo,
        playBackTime,
        playbackState,
        lastSongID,
      ];

  NowPlayingState copyWith({
    //SongInfo songInfo,
    double? playBackTime,
    PlaybackStateModel? playbackState,
    String? lastSongID,
  }) {
    return NowPlayingState(
      songInfo: songInfo ?? this.songInfo,
      playbackState: playbackState ?? this.playbackState,
      playBackTime: playBackTime ?? this.playBackTime,
      lastSongID: lastSongID ?? this.lastSongID,
    );
  }
}

class PlayerErrorState extends PlayerState {
  const PlayerErrorState({required String? lastSongID})
      : super(lastSongID: lastSongID);
}

class NoSongToPlayState extends PlayerState {
  const NoSongToPlayState({required String lastSongID})
      : super(lastSongID: lastSongID);
}