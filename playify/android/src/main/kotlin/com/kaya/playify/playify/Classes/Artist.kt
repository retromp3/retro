package com.kaya.playify.playify.Classes

class Artist {
    constructor(name: String?, albums: List<Album>?) {
        this.name = name
        this.albums = albums
    }

    ///The name of the artist.
    var name: String? = null

    ///The albums of the artist.
    var albums: List<Album>? = null

    override fun toString(): String {
        return "Artist(name=$name, albums=$albums)"
    }
}