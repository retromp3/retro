/*

      This is the design of the menu header.

*/

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:retro/music_models/playback_state/playback_state_model.dart';

import 'blocs/player/player.dart';

class MainContent extends StatelessWidget {
  final int indexContent;

  MainContent(this.indexContent);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ClipRRect(
        borderRadius: new BorderRadius.only(
            topRight: const Radius.circular(12.0),
            bottomRight: const Radius.circular(12.0)),
        child: Container()
      ),
    );
  }
}

class MenuCaption extends StatelessWidget {
  final String text;

  const MenuCaption({
    Key? key,
    String? text,
  })  : this.text = text ?? '',
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlayerBloc, PlayerState>(
      builder: (BuildContext ctx, PlayerState state) {
        final bool isPlaying = state is NowPlayingState &&
          state.playbackState == PlaybackStateModel.playing;
        return Container(
          height: 25,
          width: double.infinity,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left:5, right: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    text,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.5),
                  ),
                  Spacer(),
                  ShaderMask(
                    shaderCallback: (bounds) => RadialGradient(
                      center: Alignment.center,
                      radius: 0.5, // You can adjust this as needed
                      colors: [Colors.lightBlueAccent, Color.fromARGB(255, 45, 141, 220)],
                      tileMode: TileMode.mirror, 
                    ).createShader(bounds),
                    child: Icon(
                      isPlaying ? SFSymbols.pause_fill : SFSymbols.play_fill,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  SizedBox(width: 5),
                  Image.asset(
                    'assets/battery/full.png',
                    width: 30,
                  ),
                ],)
            ),
          ),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xFF9A9B9E), Color(0xFFFFFFFF)],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  tileMode: TileMode.clamp),
              border: Border(
                bottom: BorderSide(
                  color: Color.fromARGB(255, 140, 140, 140),
                  width: 1.0,
                ),
              ),
              ),
        );
      });
  }
}
