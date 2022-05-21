/*

  submenu constructor

*/


import 'package:flutter/material.dart';
import 'package:retro/ipod_menu_widget/ipod_menu_item.dart';

class IPodSubMenu {
  final List<IPodMenuItem> items;
  final Widget caption;
  final int visibleItemsCount;

  IPodSubMenu(
      {@required List<IPodMenuItem> items,
      @required Widget caption,
      int visibleItemsCount})
      : this.items = items ?? [],
        this.caption = caption ?? FittedBox(),
        this.visibleItemsCount =
            visibleItemsCount != null && visibleItemsCount > 0
                ? visibleItemsCount
                : 5;
}
