package com.kaya.playify.playify.Classes

class Song {
    constructor(albumTitle: String? = null, artist: String? = null, releaseDate: Long? = null,
                path: String? = null, genre: String? = null, title: String? = null,
                songID: String? = null, trackNumber: Int? = null, playCount: Int? = null,
                discNumber: Int? = null, playbackDuration: Double? = null,
                isExplicit: Boolean? = null, image: Array<Int>? = null) {
        this.albumTitle = albumTitle
        this.artist = artist
        this.releaseDate = releaseDate
        this.path = path
        this.genre = genre
        this.title = title
        this.songID = songID
        this.trackNumber = trackNumber
        this.playCount = playCount
        this.discNumber = discNumber
        this.playbackDuration = playbackDuration
        this.isExplicit = isExplicit
        this.image = image
    }

    ///The title of the album.
    var albumTitle: String?

    ///The name of the song artist.
    var artist: String?

    ///The release date of the song.
    var releaseDate: Long?

    ///The path of the song.
    var path: String?

    ///The genre of the song.
    var genre: String?

    ///The title of the song.
    var title: String?

    ///The Persistent Song ID of the song. Used to play or enqueue a song.
    var songID: String?

    ///The track number of the song in an album.
    var trackNumber: Int?

    ///The amount of times the song has been played.
    var playCount: Int?

    ///The disc number the song belongs to in an album.
    var discNumber: Int?

    ///The total playbackDuration of the song.
    var playbackDuration: Double?

    ///Shows if the song is explicit.
    var isExplicit: Boolean?

    //The album art of the song.
    var image: Array<Int>?

    fun toMap(): HashMap<String, Any?>{
        var hashMap = HashMap<String, Any?>()
        hashMap.put("albumTitle", albumTitle)
        hashMap.put("artist", artist)
        hashMap.put("releaseDate", releaseDate)
        hashMap.put("path", path)
        hashMap.put("genre", genre)
        hashMap.put("title", title)
        hashMap.put("songID", songID)
        hashMap.put("trackNumber", trackNumber)
        hashMap.put("playCount", playCount)
        hashMap.put("discNumber", discNumber)
        hashMap.put("playbackDuration", playbackDuration)
        hashMap.put("isExplicit", isExplicit)
        hashMap.put("image", image)
        return hashMap
    }

    override fun toString(): String {
        return "Song(albumTitle=$albumTitle, artist=$artist, releaseDate=$releaseDate, genre=$genre, title=$title, songID=$songID, trackNumber=$trackNumber, playCount=$playCount, discNumber=$discNumber, playbackDuration=$playbackDuration, isExplicit=$isExplicit)"
    }
}