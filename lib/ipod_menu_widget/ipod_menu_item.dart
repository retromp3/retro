import 'package:flutter/material.dart';
import 'package:retro/ipod_menu_widget/ipod_sub_menu.dart';

class IPodMenuItem {
  final String text;
  final String subText;
  final VoidCallback onTap;
  final IPodSubMenu subMenu;

  IPodMenuItem({@required String text, this.subText, this.onTap, this.subMenu})
      : assert(text != null),
        this.text = text;
}
