/*

      This is the design of the menu header.

*/

import 'package:flutter/material.dart';
import 'package:retro/ipod_menu_widget/ipod_menu_item.dart';
import 'package:retro/ipod_menu_widget/ipod_sub_menu.dart';

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
    Key key,
    String text,
  })  : this.text = text ?? '',
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 25,
      width: double.infinity,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.only(left:5),
          child: Text(
            text,
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 14.5),
          ),
        ),
      ),
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Color(0xFF9A9B9E), Color(0xFFFFFFFF)],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              tileMode: TileMode.clamp),
          ),
    );
  }
}
