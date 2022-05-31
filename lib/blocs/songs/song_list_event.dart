import 'package:equatable/equatable.dart';

abstract class SongListEvent extends Equatable {
  const SongListEvent();

  @override
  List<Object> get props => [];

  @override
  bool get stringify => super.stringify;
}

class SongListFetched extends SongListEvent {}