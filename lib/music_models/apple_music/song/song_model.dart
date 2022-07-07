import 'dart:typed_data';

class SongModel {
  final String artistName;
  final String title;
  final String songID;
  final String album;
  final double duration;
  final String additionalId;
  final Uint8List coverArtBytes;

  SongModel({
    this.artistName,
    this.title,
    this.songID,
    this.duration,
    this.additionalId,
    this.coverArtBytes,
    this.album,
  });

  @override
  String toString() {
    return 'SongModel{artistName: $artistName, title: $title, songID: $songID, album: $album, duration: $duration, additionalId: $additionalId, coverArtBytesIsEmpty: ${coverArtBytes != null ? coverArtBytes.isEmpty : true}';
  }
}
