import 'package:flutter/material.dart';
import 'package:retro/alt_menu/alt_sub_menu.dart';

class AltMenuItem {
  final String text;
  final String subText;
  final VoidCallback onTap;
  final AltSubMenu subMenu;

  AltMenuItem({@required String text, this.subText, this.onTap, this.subMenu})
      : assert(text != null),
        this.text = text;
}
