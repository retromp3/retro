import 'package:flutter/material.dart';
import 'package:retro/music_models/apple_music/song/song_model.dart';

class AlbumModel {
  final String title;
  final List<SongModel> songs;
  final String artistName;
  final Image coverArt;

  AlbumModel({
    this.title,
    List<SongModel> songs,
    this.artistName,
    this.coverArt,
  }) : this.songs = songs ?? [];

  @override
  String toString() {
    return 'AlbumModel{title: $title, songs: $songs, artistName: $artistName, coverArt: $coverArt}';
  }
}