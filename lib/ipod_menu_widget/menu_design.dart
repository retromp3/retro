/*
  
  Menu appearance

*/
import 'package:flutter/material.dart';
import 'package:retro/ipod_menu_widget/ipod_menu_widget.dart';
import 'package:retro/main.dart';

Widget buildMenu() {
  return IPodMenuWidget(
    subMenu: menu,
    key: menuKey,
    decoration: BoxDecoration(
      color: Colors.white,
      shape: BoxShape.rectangle,
      boxShadow: [
        BoxShadow(
          blurRadius: 8.0,
          offset: Offset(1.0, 0),
        ),
      ],
    ),
  );
}