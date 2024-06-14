import 'package:flutter/material.dart';
import 'package:playify/playify.dart';
import 'package:playify_example/songs.dart';

class Albums extends StatefulWidget {
  final List<Album> albums;
  Albums(this.albums);

  @override
  _AlbumsState createState() => _AlbumsState();
}

class _AlbumsState extends State<Albums> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Playify'),
        ),
        body: ListView.builder(
            itemCount: widget.albums.length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Songs(widget.albums[index].songs)));
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          WidgetStateProperty.all<Color>(Colors.blue),
                      shape: WidgetStateProperty.all<OutlinedBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Column(
                        children: <Widget>[
                          if (widget.albums[index].coverArt != null)
                            Container(
                                width: MediaQuery.of(context).size.height * 0.3,
                                height:
                                    MediaQuery.of(context).size.height * 0.3,
                                child: Image(
                                  image: Image.memory(
                                          widget.albums[index].coverArt!)
                                      .image,
                                  fit: BoxFit.fill,
                                )),
                          Text(
                            widget.albums[index].title,
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
            }));
  }
}
