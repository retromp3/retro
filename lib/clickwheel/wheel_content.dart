import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:retro/clickwheel/wheel.dart';
import 'package:retro/main.dart';

Widget menuButton() {
  return InkWell(
    onTap: () {
      menuKey?.currentState?.back();
    },
    child: Container(
      child: Text(
        'MENU',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: controlsColor,
        ),
      ),
      alignment: Alignment.topCenter,
      margin: EdgeInsets.only(top: 15),
    ),
  );
}

Widget fastForward() {
  return Container(
    child: IconButton(
        icon: Icon(
          Icons.fast_forward,
          color: controlsColor,
        ),
        iconSize: 40,
        onPressed: () async {
          HapticFeedback.mediumImpact();
        }),
    alignment: Alignment.centerRight,
    //margin: EdgeInsets.only(right: 30),
  );
}

Widget fastRewind() {
  return Container(
    child: IconButton(
        icon: Icon(
          Icons.fast_rewind,
          color: controlsColor,
        ),
        iconSize: 40,
        onPressed: () async {
          HapticFeedback.mediumImpact();
        }),
    alignment: Alignment.centerLeft,
    //margin: EdgeInsets.only(left: 30),
  );
}

Widget playButton() {
  return Container(
    child: 
      IconButton(
        icon: Icon(
          Icons.play_arrow,
          size: 40,
          color: controlsColor,
        ),
          onPressed: () async {
            /*setState(() {
              playing = true;
            });*/
            HapticFeedback.mediumImpact();
          },
      ),
    alignment: Alignment.bottomCenter,
    margin: EdgeInsets.only(bottom: 10),
  );
}

Widget selectButton() {
  return GestureDetector(
    onTap: () {
      HapticFeedback.mediumImpact();
      SystemSound.play(SystemSoundType.click);
      menuKey.currentState?.select();
    },
    child: Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF5e5e5e),
            centreColor,
          ],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(5, 5),
            blurRadius: 10,
          )
        ],
      ),
    ),
  );
}