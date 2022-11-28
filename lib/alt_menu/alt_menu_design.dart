/*
  
  Menu appearance

*/
import 'package:flutter/material.dart';
import 'package:retro/alt_menu/alt_menu_widget.dart';
import 'package:retro/main.dart';

Widget buildAltMenu() {
  return AltMenuWidget(
    subMenu: altMenu,
    key: altMenuKey,
    decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            stops: [0.7, 1.0],
            colors: [Color(0xff5e616d), Color(0xffb0b3b6)],
          ),
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(255, 36, 36, 36).withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 3,
              offset: Offset(0, -2), // changes position of shadow
            ),
          ],
        ),
  );
}

Widget signIn(context) {
    return AnimatedPositioned(
      bottom: 5,
      left: 5.5,
      right: 5.5,
      height: popUp ? MediaQuery.of(context).size.width * 0.55 : 0,
      duration: Duration(milliseconds: 200),
                                curve: Curves.easeInOut,
      child: Container(
        width: 400,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            stops: [0.2, 0.7, 1.0],
            colors: [Color(0xff3c3c43), Color(0xff5e616d), Color(0xffb0b3b6)],
          ),
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(255, 36, 36, 36).withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 3,
              offset: Offset(0, -2), // changes position of shadow
            ),
          ],
        ),
        child: Center(
          child: buildAltMenu(),
        ),
      )
    );
  }