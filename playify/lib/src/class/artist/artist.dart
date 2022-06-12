import 'package:flutter/material.dart';
import 'package:playify/src/class/album/album.dart';

class Artist {
  Artist({required this.name, required this.albums});

  ///The name of the artist.
  String name;

  ///The albums of the artist.
  List<Album> albums;

  @override
  String toString() {
    return 'Name: ' + name + ' has ' + albums.length.toString() + ' albums\n';
  }
}
