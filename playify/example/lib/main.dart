import 'dart:math';

import 'package:flutter/material.dart';
import 'package:playify/playify.dart';
import 'package:playify_example/artists.dart';
import 'package:playify_example/songs.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Playify',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePage createState() => _MyHomePage();
}

class _MyHomePage extends State<MyHomePage> {
  bool fetchingAllSongs = false;
  bool playing = false;
  SongInformation? data;
  Shuffle shufflemode = Shuffle.off;
  Repeat repeatmode = Repeat.none;
  var myplayer = Playify();
  List<Artist> artists = [];
  double time = 0.0;
  double? volume = 0.0;
  List<String> genres = [];
  String selectedGenre = "";

  Future<void> getNowPlaying() async {
    try {
      final SongInformation? res = await myplayer.nowPlaying();
      setState(() {
        data = res;
      });
    } catch (e) {
      setState(() {
        fetchingAllSongs = false;
      });
    }
  }

  Future<void> getIsPlaying() async {
    try {
      final bool isPlaying = await myplayer.isPlaying();
      setState(() {
        playing = isPlaying;
      });
    } catch (e) {
      setState(() {
        fetchingAllSongs = false;
      });
    }
  }

  Future<void> getAllGenres() async {
    try {
      final List<String> res = await myplayer.getAllGenres();
      setState(() {
        genres = res;
        if (res.isNotEmpty) {
          selectedGenre = res[0];
        }
      });
    } catch (e) {
      setState(() {
        fetchingAllSongs = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getNowPlaying().then((value) async {
      final myVolume = await myplayer.getVolume();
      setState(() {
        volume = myVolume;
      });
      await getAllGenres();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Playify'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: IgnorePointer(
              ignoring: fetchingAllSongs,
              child: Column(
                children: <Widget>[
                  if (data != null)
                    Container(
                      child: Column(
                        children: <Widget>[
                          if (data!.album.coverArt != null)
                            Image(
                              image: Image.memory(
                                data!.album.coverArt!,
                                width: 800,
                              ).image,
                              height: MediaQuery.of(context).size.height * 0.3,
                            ),
                          Slider(
                            divisions: data!.song.duration.toInt(),
                            value: time,
                            min: 0,
                            max: data!.song.duration,
                            onChanged: (val) async {
                              setState(() {
                                time = val;
                              });
                              await myplayer.setPlaybackTime(val);
                            },
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                flex: 2,
                                child: IconButton(
                                  icon: Icon(Icons.arrow_back_ios),
                                  onPressed: () async {
                                    await myplayer.previous();
                                    await getNowPlaying();
                                  },
                                ),
                              ),
                              Expanded(
                                flex: 10,
                                child: Column(
                                  children: <Widget>[
                                    Text(data!.artist.name),
                                    Text(data!.album.title),
                                    Text(data!.song.title),
                                    Text(data!.song.trackNumber.toString() +
                                        "/" +
                                        data!.album.albumTrackCount.toString()),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: IconButton(
                                  icon: Icon(Icons.arrow_forward_ios),
                                  onPressed: () async {
                                    await myplayer.next();
                                    await getNowPlaying();
                                  },
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  StreamBuilder<PlayifyStatus>(
                      stream: myplayer.statusStream,
                      builder: (context, snapshot) {
                        if (snapshot.data != PlayifyStatus.playing) {
                          return IconButton(
                            icon: Icon(Icons.play_arrow),
                            onPressed: () async {
                              await myplayer.play();
                              await getNowPlaying();
                            },
                          );
                        } else {
                          return IconButton(
                            icon: Icon(Icons.pause),
                            onPressed: () async {
                              await myplayer.pause();
                              await getNowPlaying();
                            },
                          );
                        }
                      }),
                  TextButton(
                    child: Text("Get IsPlaying"),
                    onPressed: () async {
                      await getIsPlaying();
                    },
                  ),
                  TextButton(
                    child: Text("Get Now Playing Info"),
                    onPressed: () async {
                      await getNowPlaying();
                    },
                  ),
                  TextButton(
                    child: Text("Play Random Song"),
                    onPressed: () async {
                      final randomArtist =
                          artists[Random().nextInt(artists.length)];
                      final randomAlbum = randomArtist
                          .albums[Random().nextInt(randomArtist.albums.length)];
                      final randomSong = randomAlbum
                          .songs[Random().nextInt(randomAlbum.songs.length)];
                      await myplayer.playItem(songID: randomSong.iOSSongID);
                      await getNowPlaying();
                    },
                  ),
                  TextButton(
                    child: Text("All Songs"),
                    onPressed: () async {
                      setState(() {
                        fetchingAllSongs = true;
                      });

                      final List<Artist> res =
                          await myplayer.getAllSongs(sort: true);
                      print(res);
                      setState(() {
                        artists = res;
                        fetchingAllSongs = false;
                      });
                    },
                  ),
                  TextButton(
                    child: Text("Artists"),
                    onPressed: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Artists(
                                    artists,
                                  )));
                    },
                  ),
                  Slider(
                    label: volume?.toStringAsFixed(2),
                    divisions: 20,
                    value: volume ?? 0,
                    min: 0,
                    max: 1,
                    onChanged: (val) async {
                      setState(() {
                        volume = val;
                      });
                      await myplayer.setVolume(val);
                    },
                  ),
                  TextButton(
                    child: Text("Get Volume"),
                    onPressed: () async {
                      final myVolume = await myplayer.getVolume();
                      setState(() {
                        volume = myVolume;
                      });
                    },
                  ),
                  TextButton(
                    child: Text("Get Playback Time"),
                    onPressed: () async {
                      final playbackTime = await myplayer.getPlaybackTime();
                      print(playbackTime);
                    },
                  ),
                  TextButton(
                    child: Text("Seek Forward"),
                    onPressed: () async {
                      await myplayer.seekForward();
                    },
                  ),
                  TextButton(
                    child: Text("Seek Backward"),
                    onPressed: () async {
                      await myplayer.seekBackward();
                    },
                  ),
                  TextButton(
                    child: Text("End Seek"),
                    onPressed: () async {
                      await myplayer.endSeeking();
                    },
                  ),
                  TextButton(
                    child: Text("Skip To Beginning"),
                    onPressed: () async {
                      await myplayer.skipToBeginning();
                    },
                  ),
                  TextButton(
                    child: Text("Get Playlists"),
                    onPressed: () async {
                      final playlists = await myplayer.getPlaylists();
                      print(playlists);
                    },
                  ),
                  TextButton(
                    child: Text("Get Shuffle Mode"),
                    onPressed: () async {
                      final shuffleMode = await myplayer.getShuffleMode();
                      print(shuffleMode);
                    },
                  ),
                  TextButton(
                    child: Text("Get Repeat Mode"),
                    onPressed: () async {
                      final repeatMode = await myplayer.getRepeatMode();
                      print(repeatMode);
                    },
                  ),
                  Text("Shuffle:"),
                  DropdownButton<Shuffle>(
                    hint: Text("Shuffle"),
                    onChanged: (mode) async {
                      if (mode != null) {
                        await myplayer.setShuffleMode(mode);
                        setState(() {
                          shufflemode = mode;
                        });
                      }
                    },
                    value: shufflemode,
                    items: [
                      DropdownMenuItem(
                        value: Shuffle.off,
                        child: Text("Off"),
                      ),
                      DropdownMenuItem(
                        value: Shuffle.songs,
                        child: Text("Songs"),
                      ),
                    ],
                  ),
                  Text("Repeat:"),
                  DropdownButton<Repeat>(
                    hint: Text("Repeat"),
                    onChanged: (mode) async {
                      if (mode != null) {
                        await myplayer.setRepeatMode(mode);
                        setState(() {
                          repeatmode = mode;
                        });
                      }
                    },
                    value: repeatmode,
                    items: [
                      DropdownMenuItem(
                        value: Repeat.none,
                        child: Text("None"),
                      ),
                      DropdownMenuItem(
                        value: Repeat.one,
                        child: Text("One"),
                      ),
                      DropdownMenuItem(
                        value: Repeat.all,
                        child: Text("All"),
                      )
                    ],
                  ),
                  Text("Genres:"),
                  DropdownButton<String>(
                    hint: Text("Genres"),
                    onChanged: (genre) async {
                      if (genre != null) {
                        setState(() {
                          selectedGenre = genre;
                        });
                      }
                    },
                    value: selectedGenre,
                    items: genres.map((genre) {
                      return DropdownMenuItem(
                        value: genre,
                        child: Text(genre),
                      );
                    }).toList(),
                  ),
                  TextButton(
                    child: Text("Get Songs With Selected Genre"),
                    onPressed: () async {
                      final songs = await myplayer.getSongsByGenre(genre: selectedGenre);
                      print(songs);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Songs(
                            songs,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
