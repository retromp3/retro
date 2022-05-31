import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:playify/playify.dart';
import 'package:retro/blocs/songs/song_list_event.dart';
import 'package:retro/blocs/songs/song_list_state.dart';

class SongListBloc extends Bloc<SongListEvent, SongListState> {
  final Playify _playify;

  SongListBloc(Playify playify)
      : assert(playify != null),
        this._playify = playify,
        super(SongListInProgress());

  @override
  Stream<SongListState> mapEventToState(SongListEvent event) async* {
    if (event is SongListFetched) {
      yield* _mapSongListFetched(event);
    }
  }

  Stream<SongListState> _mapSongListFetched(SongListFetched event) async* {
    try {
      if (await Permission.mediaLibrary.request().isGranted) {
        final List<Artist> artistList = await _playify.getAllSongs();
        yield SongListFetchSuccess(artistList);
        print(artistList);
      }
    } catch (e) {
      yield SongListFetchError();
      print(e);
    }
  }
}