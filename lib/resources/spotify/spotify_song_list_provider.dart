import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:retro/music_models/apple_music/album/album_model.dart';
import 'package:retro/music_models/apple_music/artist/artist_model.dart';
import 'package:retro/music_models/apple_music/song/song_info_model.dart';
import 'package:retro/music_models/apple_music/song/song_model.dart';
import 'package:retro/music_models/playlist/playlist_model.dart';
import 'package:retro/music_models/spotify/album/spotify_album_model.dart';
import 'package:retro/music_models/spotify/track/spotify_track_model.dart';
import 'package:retro/resources/resources.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotify_sdk/spotify_sdk.dart';
import 'package:http/http.dart' as http;

class SpotifySongListProvider extends SongListProvider {
  static String _redirectUrl = dotenv.env['SPOTIFY_REDIRECT_URL'];
  static String _clientID = dotenv.env['SPOTIFY_CLIENT_ID'];
  static const String _spotifyHost = 'api.spotify.com';
  static const String _spotifyPlayListEndpoint = '/v1/me/playlists';
  static const String _authHeader = 'Authorization';
  static const String _spotifyScope =
      'playlist-read-collaborative,playlist-read-private';
  static const String _tokenKey = 'spotifyTokenKey';
  static const String _itemsField = 'items';
  static const String _trackField = 'track';

  static String _spotifyPlayListItemsEndpoint(String id) =>
      '/v1/playlists/$id/tracks';

  final http.Client _client = http.Client();

  static SpotifySongListProvider _instance =
      SpotifySongListProvider._internal();

  final Completer<String> _tokenCompleter = Completer();

  SpotifySongListProvider._internal();

  factory SpotifySongListProvider() {
    return _instance;
  }

  @override
  void dispose() {
    // _client.close();
  }

  @override
  Future<List<ArtistModel>> fetchAllSongs(String playlistID) async {
    final Uri uri =
        Uri.https(_spotifyHost, _spotifyPlayListItemsEndpoint(playlistID));
    final http.Response response = await _client.get(
      uri,
      headers: await _getAuthHeader(),
    );
    if (response.statusCode != 200) return Future.error(response.body);
    return _getPlayListItems(response.body);
  }

  List<ArtistModel> _getPlayListItems(String response) {
    final Map<String, dynamic> responseJson = jsonDecode(response);
    List items = responseJson[_itemsField];
    List<SpotifyTrackModel> trackList = [];

    items?.forEach((element) {
      trackList.add(SpotifyTrackModel.fromJson(element[_trackField]));
    });

    Map<String, List<SpotifyTrackModel>> albumsMap = {};
    Map<String, List<SpotifyAlbumModel>> artistsMap = {};

    trackList.forEach((SpotifyTrackModel track) {
      final List<SpotifyTrackModel> tracks = albumsMap[track.album.name] ?? [];
      tracks.add(track);
      albumsMap[track.album.name] = tracks;
    });

    List<ArtistModel> artistList = [];

    albumsMap.forEach((key, List<SpotifyTrackModel> value) {
      final String artist = value[0].album.artists[0].name;
      final List<SpotifyAlbumModel> albums = artistsMap[artist] ?? [];
      albums.add(value[0].album);
      artistsMap[artist] = albums;
    });

    artistsMap.forEach((artistName, List<SpotifyAlbumModel> albums) {
      List<AlbumModel> albumList = _getAlbumList(albums, albumsMap, artistName);

      artistList.add(ArtistModel(
        name: artistName,
        albums: albumList,
      ));
    });

    return artistList;
  }

  List<AlbumModel> _getAlbumList(List<SpotifyAlbumModel> albums,
      Map<String, List<SpotifyTrackModel>> albumsMap, String artistName) {
    List<AlbumModel> albumList =
        albums.map((SpotifyAlbumModel spotifyAlbumModel) {
      List<SongModel> songList = _getSongList(
        albumsMap,
        spotifyAlbumModel,
        artistName,
      );

      return AlbumModel(
        artistName: artistName,
        title: spotifyAlbumModel.name,
        songs: songList,
        coverArt: Image.network(spotifyAlbumModel.images.first.url),
      );
    }).toList();
    return albumList;
  }

  List<SongModel> _getSongList(Map<String, List<SpotifyTrackModel>> albumsMap,
      SpotifyAlbumModel spotifyAlbumModel, String artistName) {
    List<SongModel> songList = albumsMap[spotifyAlbumModel.name]
        .map((SpotifyTrackModel spotifyTrackModel) => SongModel(
              title: spotifyTrackModel.name,
              artistName: artistName,
              songID: spotifyTrackModel.uri,
              duration: spotifyTrackModel.duration / 1000,
            ))
        .toList();
    return songList;
  }

  @override
  Future<List<PlaylistModel>> fetchUsersPlaylist() async {
    final Uri uri = Uri.https(_spotifyHost, _spotifyPlayListEndpoint);
    final http.Response response = await _client.get(
      uri,
      headers: await _getAuthHeader(),
    );
    if (response.statusCode != 200) return Future.error(response.body);

    return _getPlayList(response.body);
  }

  List<PlaylistModel> _getPlayList(String response) {
    final Map<String, dynamic> responseJson = jsonDecode(response);
    List<PlaylistModel> playLists = [];
    List items = responseJson[_itemsField];
    items?.forEach((value) {
      playLists.add(PlaylistModel.fromJson(value));
    });

    return playLists;
  }

  Future<Map<String, String>> _getAuthHeader() async {
    final String token = await _tokenCompleter.future;
    return {_authHeader: 'Bearer $token'};
  }

  void _getAuthToken() async {
    if (_tokenCompleter.isCompleted) return;
    final String savedToken = await _getSavedToken();
    if (savedToken != null && savedToken.isNotEmpty) {
      final Uri uri = Uri.https(_spotifyHost, _spotifyPlayListEndpoint);
      final http.Response response = await _client.get(
        uri,
        headers: {_authHeader: 'Bearer $savedToken'},
      );
      if (response.statusCode >= 400 && response.statusCode < 500) {
        _getTokenFromSDK();
      } else {
        _tokenCompleter.complete(savedToken);
      }
    } else {
      _getTokenFromSDK();
    }
  }

  Future<String> _getSavedToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(_tokenKey);
  }

  void _saveToken(String token) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(_tokenKey, token);
  }

  void _getTokenFromSDK() async {
    final String token = await SpotifySdk.getAccessToken(
      clientId: _clientID,
      redirectUrl: _redirectUrl,
      scope: _spotifyScope,
    );
    _tokenCompleter.complete(token);
    _saveToken(token);
  }

  @override
  Future<bool> connect() async {
    _getAuthToken();
    return true;
  }

  @override
  Future<List<SongModel>> fetchSongsBelow(String songId) async => [];
}
