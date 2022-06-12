package com.kaya.playify.playify

import android.content.Context
import android.database.Cursor
import android.graphics.BitmapFactory
import android.provider.MediaStore
import android.util.Log
import com.kaya.playify.playify.Classes.Song
import java.nio.ByteBuffer
import java.util.*
import kotlin.collections.ArrayList


class PlayifyPlayer {
    fun getAllSongs(context: Context): Array<Song> {
        var songs = ArrayList<Song>()
        val selection = MediaStore.Audio.Media.IS_MUSIC + " != 0"

        val projection = arrayOf(
                MediaStore.Audio.Media._ID,
                MediaStore.Audio.Media.ARTIST,
                MediaStore.Audio.Media.ALBUM,
                MediaStore.Audio.Media.TITLE,
                MediaStore.Audio.Media.DATA,
                MediaStore.Audio.Media.DURATION,
                MediaStore.Audio.Media.YEAR,
                MediaStore.Audio.Media.TRACK
        )

        val genresProjection = arrayOf(
                MediaStore.Audio.Genres.NAME
        )

        val albumArtProjection = arrayOf(
                MediaStore.Audio.Albums.ALBUM_ART
        )

        val cursor: Cursor? = context?.getContentResolver()?.query(
                MediaStore.Audio.Media.EXTERNAL_CONTENT_URI,
                projection,
                selection,
                null,
                null)

        if (cursor != null) {
            while (cursor.moveToNext()) {
                val id = cursor.getString(0)
                val artist = cursor.getString(1)
                val albumTitle = cursor.getString(2)
                val songTitle = cursor.getString(3)
                val path = cursor.getString(4)
                val playbackDuration = cursor.getString(5)
                val releaseYearStr = cursor.getString(6)
                val trackStr = cursor.getString(7)
                val track = Integer.parseInt(trackStr)
                val calendar = Calendar.getInstance();

                calendar.set(Integer.parseInt(releaseYearStr), 0, 1)
                val releaseYear = calendar.timeInMillis

                val song = Song(albumTitle = albumTitle, artist = artist, title = songTitle,
                        path = path, playbackDuration = playbackDuration.toDoubleOrNull(), releaseDate = releaseYear,
                        trackNumber = track, songID = id)

                val albumArtCursor: Cursor? = context?.getContentResolver()?.query(
                        MediaStore.Audio.Albums.EXTERNAL_CONTENT_URI,
                        albumArtProjection,
                        null,
                        null,
                        null)

                albumArtCursor?.moveToNext()

                val albumArt = albumArtCursor?.getString(0)

                Log.d("playify", albumArt)

                val bitmap = BitmapFactory.decodeFile(albumArt)

                val size: Int = bitmap.getRowBytes() * bitmap.getHeight()
                val byteBuffer: ByteBuffer = ByteBuffer.allocate(size)
                bitmap.copyPixelsToBuffer(byteBuffer)
                val intBuffer = byteBuffer.asIntBuffer()

                val intArray = IntArray(intBuffer.limit())

                intBuffer.get(intArray)
                val typedIntArray = intArray.toTypedArray()

                //Log.d("playify", typedIntArray.size.toString())

                song.image = typedIntArray

                //Get the genre
                val genreUri = MediaStore.Audio.Genres.getContentUriForAudioId("external",
                        Integer.parseInt(id))

                val genreCursor: Cursor? = context?.getContentResolver()?.query(
                        genreUri,
                        genresProjection,
                        null,
                        null,
                        null)

                genreCursor?.moveToNext()

                val genreName = genreCursor?.getString(0)
                song.genre = genreName


                Log.d("playify", song.toString())

                genreCursor?.close()

                songs.add(song)
            }
            cursor.close()
        }
        return songs.toTypedArray()
    }
}