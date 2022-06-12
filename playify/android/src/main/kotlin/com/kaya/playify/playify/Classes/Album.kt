package com.kaya.playify.playify.Classes

class Album {
    constructor(title: String? = null, songs: List<Song>? = null, artistName: String? = null,
                albumTrackCount: Int? = null, coverArt: Array<Int>? = null, discCount: Int? = null) {
        this.title = title
        this.songs = songs
        this.artistName = artistName
        this.albumTrackCount = albumTrackCount
        this.coverArt = coverArt
        this.discCount = discCount
    }

    ///The title of the album.
    var title: String?

    ///The songs of the album.
    var songs: List<Song>?

    ///The name of the artist of the album.
    var artistName: String?

    ///The total tracks that the album has.
    ///
    ///This may not be equal to the total songs of the album that a user has on
    ///their device, since a song in an album may not exist on the device.
    var albumTrackCount: Int?

    ///The cover art as a `UInt8List`. This can be used with `Image.memory()` to
    ///convert to an image and display in the UI.
    var coverArt: Array<Int>?

    ///The total disc number of the album.
    var discCount: Int?

    override fun toString(): String {
        return "Album(title=$title, songs=$songs, artistName=$artistName, albumTrackCount=$albumTrackCount, coverArt=${coverArt?.contentToString()}, discCount=$discCount)"
    }
}