/*

  submenu constructor

*/

import 'package:flutter/material.dart';
import 'package:retro/ipod_menu_widget/ipod_menu_item.dart';

typedef IPodMenuItemBuilder = List<IPodMenuItem> Function();

class IPodSubMenu {
  final List<IPodMenuItem> items;
  final IPodMenuItemBuilder itemsBuilder;
  final Widget caption;
  final int visibleItemsCount;

  IPodSubMenu(
      {List<IPodMenuItem> items,
      @required Widget caption,
      IPodMenuItemBuilder itemsBuilder,
      int visibleItemsCount})
      : this.items = items ?? [],
        this.itemsBuilder = itemsBuilder,
        this.caption = caption ?? FittedBox(),
        this.visibleItemsCount =
            visibleItemsCount != null && visibleItemsCount > 0
                ? visibleItemsCount
                : 5;
}
