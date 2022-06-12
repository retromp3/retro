import 'package:flutter/material.dart';
import 'package:playify_example/albums.dart';
import 'package:playify/playify.dart';

class Artists extends StatefulWidget {
  final List<Artist> artists;
  Artists(this.artists);

  @override
  _ArtistsState createState() => _ArtistsState();
}

class _ArtistsState extends State<Artists> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Playify'),
      ),
      body: ListView.builder(
        itemCount: widget.artists.length,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              Albums(widget.artists[index].albums)));
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
                  child: Text(widget.artists[index].name,
                      style: TextStyle(color: Colors.white)),
                ),
              ),
              Divider(
                color: Color.fromRGBO(220, 220, 220, 1),
              )
            ],
          );
        },
      ),
    );
  }
}
