import 'dart:typed_data';

import 'package:flutter/material.dart';

class SongInfoModel {
  final String albumTitle;
  final String artistName;
  final String title;
  final String songID;
  final double duration;
  final Image coverArt;
  final Uint8List coverArtBytes;

  SongInfoModel({
    this.albumTitle = '',
    this.artistName = '',
    this.title = '',
    this.songID = '',
    this.duration = 0,
    this.coverArt,
    this.coverArtBytes,
  });

  @override
  String toString() {
    return 'SongInfoModel{albumTitle: $albumTitle, artistName: $artistName, title: $title, songID: $songID, duration: $duration, coverArt: $coverArt, coverArtBytes: $coverArtBytes}';
  }
}
