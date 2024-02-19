import 'package:equatable/equatable.dart';

abstract class PlayerEvent extends Equatable {
  const PlayerEvent();

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [];
}

class NowPlayingFetched extends PlayerEvent {}

class PlayCalled extends PlayerEvent {}

class PauseCalled extends PlayerEvent {}

class ShuffleCalled extends PlayerEvent {}

class NextCalled extends PlayerEvent {
  final List<String?>? songIDs;

  const NextCalled(this.songIDs);

  @override
  List<Object?> get props => [songIDs];
}

class PrevCalled extends PlayerEvent {
  final List<String?>? songIDs;

  const PrevCalled(this.songIDs);

  @override
  List<Object?> get props => [songIDs];
}

class FRewindCalled extends PlayerEvent {}

class BRewindCalled extends PlayerEvent {}

class SetQueueItem extends PlayerEvent {
  final String? songId;

  SetQueueItem(this.songId);

  @override
  List<Object?> get props => [songId];
}