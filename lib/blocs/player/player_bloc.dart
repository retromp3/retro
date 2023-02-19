import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:retro/blocs/player/player.dart';
import 'package:retro/music_models/apple_music/song/song_info_model.dart';
import 'package:retro/music_models/playback_state/playback_state_model.dart';
import 'package:retro/resources/resources.dart';

class PlayerBloc extends Bloc<PlayerEvent, PlayerState> {
  final PlayerRepository _playerRepository;

  PlayerBloc(PlayerRepository playerRepository)
      : assert(playerRepository != null),
        this._playerRepository = playerRepository,
        super(PlayerUnknownState());

  @override
  Stream<PlayerState> mapEventToState(PlayerEvent event) async* {
    if (event is NowPlayingFetched) {
      yield* _mapNowPlayingFetched(event);
    } else if (event is PlayCalled) {
      yield* _mapPlayCalled(event);
    } else if (event is SetQueueItem) {
      yield* _mapSetQueueItem(event);
    } else if (event is PauseCalled) {
      yield* _mapPauseCalled(event);
    } else if (event is ShuffleCalled) {
      yield* _mapToggleShuffleCalled(event);
    } else if (event is PrevCalled) {
      yield* _mapPrevCalled(event);
    } else if (event is NextCalled) {
      yield* _mapNextCalled(event);
    } else if (event is FRewindCalled) {
      yield* _mapFRewindCalled(event);
    } else if (event is BRewindCalled) {
      yield* _mapBRewindCalled(event);
    }
  }

  Stream<PlayerState> _mapNowPlayingFetched(NowPlayingFetched event) async* {
    yield* _getNowPlayingState();
  }

  Stream<PlayerState> _getNowPlayingState() async* {
    try {
      final SongInfoModel songInfo = await _playerRepository.getNowPlaying();
      final PlaybackStateModel playbackState =
          await _playerRepository.getPlaybackState();
      final double playBackTime = await _playerRepository.getPlaybackTime();
      if (state is NowPlayingState &&
          songInfo.songID == (state as NowPlayingState).songInfo.songID) {
        yield (state as NowPlayingState).copyWith(
          playBackTime: playBackTime,
          playbackState: playbackState,
        );
      } else {
        yield NowPlayingState(
          songInfo: songInfo,
          playBackTime: playBackTime,
          playbackState: playbackState,
          lastSongID: songInfo.songID,
        );
      }
    } catch (e) {
      yield PlayerErrorState(lastSongID: state.lastSongID);
    }
  }

  Stream<PlayerState> _mapPlayCalled(PlayCalled event) async* {
    try {
      await _playerRepository.play();
      yield* _getNowPlayingState();
    } catch (e) {
      yield PlayerErrorState(lastSongID: state.lastSongID);
    }
  }

  Stream<PlayerState> _mapSetQueueItem(SetQueueItem event) async* {
    try {
      await _playerRepository.setQueue(event.songId);
      yield* _getNowPlayingState();
    } catch (e) {
      yield PlayerErrorState(lastSongID: state.lastSongID);
    }
  }

  Stream<PlayerState> _mapPauseCalled(PauseCalled event) async* {
    try {
      await _playerRepository.pause();
      yield* _getNowPlayingState();
    } catch (e) {
      yield PlayerErrorState(lastSongID: state.lastSongID);
    }
  }

  Stream<PlayerState> _mapToggleShuffleCalled(ShuffleCalled event) async* {
    try {
      await _playerRepository.toggleShuffle();
      yield* _getNowPlayingState();
    } catch (e) {
      yield PlayerErrorState(lastSongID: state.lastSongID);
    }
  }

  Stream<PlayerState> _mapPrevCalled(PrevCalled event) async* {
    yield* _playSongWithRelativeIndex(event.songIDs, -1);
  }

  Stream<PlayerState> _mapNextCalled(NextCalled event) async* {
    yield* _playSongWithRelativeIndex(event.songIDs, 1);
  }

  Stream<PlayerState> _playSongWithRelativeIndex(
    List<String> songIDs,
    int relIndex,
  ) async* {
    try {
      if (songIDs != null && songIDs.isNotEmpty) {
        final String curId = _getCurrentSongId();
        final int songIndexToPlay =
            _getNextSongIndexToPlay(songIDs, curId, relIndex);
        await _playerRepository.setQueue(songIDs[songIndexToPlay]);
        yield* _getNowPlayingState();
      }
    } catch (e) {
      yield PlayerErrorState(lastSongID: state.lastSongID);
    }
  }

  int _getNextSongIndexToPlay(
    List<String> songIDs,
    String curId,
    int relIndex,
  ) {
    int songIndexToPlay = 0;
    final int index = songIDs.indexOf(curId);
    if (index != -1) {
      songIndexToPlay = index + relIndex;
      if (songIndexToPlay < 0) {
        songIndexToPlay = songIDs.length - 1;
      } else if (songIndexToPlay >= songIDs.length) {
        songIndexToPlay = 0;
      }
    }
    return songIndexToPlay;
  }

  String _getCurrentSongId() {
    String curId = 'unknown';
    if (state is NowPlayingState) {
      curId = (state as NowPlayingState).songInfo.songID;
    } else {
      curId = state.lastSongID;
    }
    return curId;
  }

  Stream<PlayerState> _mapFRewindCalled(FRewindCalled event) async* {
    if (state is NowPlayingState &&
        (state as NowPlayingState).playbackState ==
            PlaybackStateModel.playing) {
      final double newTime = (state as NowPlayingState).playBackTime - 5;
      try {
        await _playerRepository.setPlaybackTime(newTime < 0 ? 0 : newTime);
        yield* _getNowPlayingState();
      } catch (e) {
        yield PlayerErrorState(lastSongID: state.lastSongID);
      }
    }
  }

  Stream<PlayerState> _mapBRewindCalled(BRewindCalled event) async* {
    if (state is NowPlayingState &&
        (state as NowPlayingState).playbackState ==
            PlaybackStateModel.playing) {
      final NowPlayingState nowPlayingState = state;
      final double newTime = nowPlayingState.playBackTime + 5;
      final double duration = nowPlayingState.songInfo.duration;
      try {
        await _playerRepository
            .setPlaybackTime(newTime > duration ? duration : newTime);
        yield* _getNowPlayingState();
      } catch (e) {
        yield PlayerErrorState(lastSongID: state.lastSongID);
      }
    }
  }
}