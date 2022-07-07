import 'package:flutter/material.dart';
import 'package:playify/src/class/album/album.dart';
import 'package:playify/src/class/artist/artist.dart';
import 'package:playify/src/class/song/song.dart';

class SongInformation {
  SongInformation(
      {required this.album, required this.song, required this.artist});

  ///The album of the song.
  Album album;

  ///The song.
  Song song;

  ///The artist of the song.
  Artist artist;

  @override
  String toString() {
    return 'Artist: ' +
        artist.toString() +
        'Album: ' +
        album.toString() +
        'Song: ' +
        song.toString();
  }
}
