import 'package:flutter/material.dart';
import 'package:playify/playify.dart';

class Songs extends StatefulWidget {
  final List<Song> songs;
  Songs(this.songs);

  @override
  _SongsState createState() => _SongsState();
}

class _SongsState extends State<Songs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Playify'),
        ),
        body: ListView.builder(
          itemCount: widget.songs.length,
          itemBuilder: (BuildContext context, int index) {
            return Column(
              children: <Widget>[
                TextButton(
                  onPressed: () async {
                    final List<String> songs = [];
                    for (int i = 0; i < widget.songs.length; i++) {
                      songs.add(widget.songs[i].iOSSongID);
                    }
                    final Playify myplayer = Playify();
                    await myplayer.setQueue(
                        songIDs: songs, startID: songs[index]);
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.blue),
                    shape: MaterialStateProperty.all<OutlinedBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Column(
                      children: <Widget>[
                        Text(
                          widget.songs[index].trackNumber.toString() +
                              ". " +
                              widget.songs[index].title,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(
                  color: Color.fromRGBO(220, 220, 220, 1),
                )
              ],
            );
          },
        ));
  }
}
