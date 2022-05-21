import 'package:flutter/material.dart';
import 'package:retro/ipod_menu_widget/ipod_menu_page_widget.dart';

import 'ipod_sub_menu.dart';

class IPodMenuWidget extends StatefulWidget {
  final IPodSubMenu subMenu;
  final LinearGradient selectionColor;
  final Decoration decoration;
  final TextStyle itemTextStyle;
  final TextStyle selectedItemTextStyle;
  final Widget subMenuIcon;
  final Widget selectedSubMenuIcon;

  IPodMenuWidget({
    Key key,
    @required IPodSubMenu subMenu,
    Color selectionColor,
    this.decoration,
    this.itemTextStyle,
    this.selectedItemTextStyle,
    this.subMenuIcon,
    this.selectedSubMenuIcon,
  })  : assert(subMenu != null),
        this.subMenu = subMenu,
        this.selectionColor = selectionColor ??
            LinearGradient(
              colors: [
                Color(0xFF0168C7),
                Color(0xFF39AFDA),
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
        super(key: key);

  @override
  IPodMenuWidgetState createState() => IPodMenuWidgetState();
}

class IPodMenuWidgetState extends State<IPodMenuWidget> {
  final List<Widget> _pages = [];
  final List<GlobalKey<IPodMenuPageWidgetState>> _keys = [];

  @override
  void initState() {
    super.initState();
    _keys.add(GlobalKey());
    _pages.add(IPodMenuPageWidget(
      key: _keys.last,
      subMenu: widget.subMenu,
      decoration: widget.decoration,
      selectionColor: widget.selectionColor,
      isAnimated: false,
      itemTextStyle: widget.itemTextStyle,
      selectedItemTextStyle: widget.selectedItemTextStyle,
      subMenuIcon: widget.subMenuIcon,
      selectedSubMenuIcon: widget.selectedSubMenuIcon,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: _pages);
  }

  void up() {
    _keys.last?.currentState?.decreaseSelectedIndex();
  }

  void down() {
    _keys.last?.currentState?.increaseSelectedIndex();
  }

  void select() {
    final IPodSubMenu newMenu = _keys.last?.currentState?.tap();
    if (newMenu != null) {
      setState(() {
        _keys.add(GlobalKey());
        _pages.add(
          IPodMenuPageWidget(
            key: _keys.last,
            subMenu: newMenu,
            decoration: widget.decoration,
            selectionColor: widget.selectionColor,
            onBackAnimationComplete: _backAnimationCompleteListener,
            itemTextStyle: widget.itemTextStyle,
            selectedItemTextStyle: widget.selectedItemTextStyle,
            subMenuIcon: widget.subMenuIcon,
            selectedSubMenuIcon: widget.selectedSubMenuIcon,
          ),
        );
      });
    }
  }

  void _backAnimationCompleteListener() {
    setState(() {
      _keys.removeLast();
      _pages.removeLast();
    });
  }

  void back() {
    if (_keys.length > 1) {
      _keys.last.currentState?.back();
    }
  }
}
