import 'package:flutter/material.dart';
import 'package:retro/alt_menu/alt_menu_page_widget.dart';

import 'alt_sub_menu.dart';

class AltMenuWidget extends StatefulWidget {
  final AltSubMenu subMenu;
  final LinearGradient selectionColor;
  final Decoration? decoration;
  final TextStyle? itemTextStyle;
  final TextStyle? selectedItemTextStyle;
  final Widget? subMenuIcon;
  final Widget? selectedSubMenuIcon;

  AltMenuWidget({
    Key? key,
    required AltSubMenu subMenu,
    Color? selectionColor,
    this.decoration,
    this.itemTextStyle,
    this.selectedItemTextStyle,
    this.subMenuIcon,
    this.selectedSubMenuIcon,
  })  : this.subMenu = subMenu,
        this.selectionColor = selectionColor as LinearGradient? ??
            LinearGradient(
              colors: [
                Color(0xFF1F7BC4),
                Color(0xFF3BB3EF),
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
        super(key: key);

  @override
  AltMenuWidgetState createState() => AltMenuWidgetState();
}

class AltMenuWidgetState extends State<AltMenuWidget> {
  final List<Widget> _pages = [];
  final List<GlobalKey<AltMenuPageWidgetState>> _keys = [];

  @override
  void initState() {
    _keys.add(GlobalKey());
    _pages.add(AltMenuPageWidget(
      key: _keys.last,
      subMenu: widget.subMenu,
      decoration: widget.decoration,
      selectionColor: widget.selectionColor,
      itemTextStyle: widget.itemTextStyle,
      selectedItemTextStyle: widget.selectedItemTextStyle,
    ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: _pages);
  }

  void up(bool haptics) {
    _keys.last.currentState?.decreaseSelectedIndex(haptics);
  }

  void down(bool haptics) {
    _keys.last.currentState?.increaseSelectedIndex(haptics);
  }

  void select() {
    final AltSubMenu? newMenu = _keys.last.currentState?.tap();
    if (newMenu != null) {
      setState(() {
        _keys.add(GlobalKey());
        _pages.add(
          AltMenuPageWidget(
            key: _keys.last,
            subMenu: newMenu,
            decoration: widget.decoration,
            selectionColor: widget.selectionColor,
            itemTextStyle: widget.itemTextStyle,
            selectedItemTextStyle: widget.selectedItemTextStyle,
          ),
        );
      });
    }
  }

}

