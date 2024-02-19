/*

  submenu constructor

*/

import 'package:flutter/material.dart';
import 'package:retro/alt_menu/alt_menu_item.dart';

typedef AltMenuItemBuilder = List<AltMenuItem> Function();

class AltSubMenu {
  final List<AltMenuItem> items;
  final AltMenuItemBuilder? itemsBuilder;
  final Widget caption;
  final int visibleItemsCount;

  AltSubMenu(
      {List<AltMenuItem>? items,
      Widget? caption,
      AltMenuItemBuilder? itemsBuilder,
      int? visibleItemsCount})
      : this.items = items ?? [],
        this.itemsBuilder = itemsBuilder,
        this.caption = caption ?? FittedBox(),
        this.visibleItemsCount =
            visibleItemsCount != null && visibleItemsCount > 0
                ? visibleItemsCount
                : 5;
}
