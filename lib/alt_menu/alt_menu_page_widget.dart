/*
  
  Controls how the menu list looks and handles basic menu animations.

*/

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:retro/alt_menu/alt_menu_item.dart';
import 'package:retro/alt_menu/alt_sub_menu.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class AltMenuPageWidget extends StatefulWidget {
  final AltSubMenu subMenu;
  final LinearGradient selectionColor;
  final Decoration decoration;
  final TextStyle itemTextStyle;
  final TextStyle selectedItemTextStyle;
  final TextStyle cancelButtonTextStyle;

  AltMenuPageWidget({
    Key key,
    @required AltSubMenu subMenu,
    LinearGradient selectionColor,
    this.decoration,
    TextStyle itemTextStyle,
    TextStyle selectedItemTextStyle,
    TextStyle cancelButtonTextStyle,
  })  : assert(subMenu != null),
        this.subMenu = subMenu,
        this.selectionColor = selectionColor ??
            LinearGradient(
              colors: [
                Color(0xFF1F7BC4),
                Color(0xFF3BB3EF),
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
        this.itemTextStyle = itemTextStyle ??
            TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontSize: 17),
        this.selectedItemTextStyle = selectedItemTextStyle ??
            TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 17),
        this.cancelButtonTextStyle = cancelButtonTextStyle ?? TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 17),
        super(key: key);

  @override
  AltMenuPageWidgetState createState() => AltMenuPageWidgetState();
}

class AltMenuPageWidgetState extends State<AltMenuPageWidget>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  int _startVisibleIndex;
  int _endVisibleIndex;
  int _visibleItemsCount;
  final ItemScrollController _scrollController = ItemScrollController();
  final ItemPositionsListener _itemPositionsListener =
      ItemPositionsListener.create();

  List<AltMenuItem> _menuItems;
  Widget _captionItem;

  @override
  void initState() {
    super.initState();
    _initValues();
    _menuItems = widget.subMenu.itemsBuilder != null
        ? widget.subMenu.itemsBuilder()
        : widget.subMenu.items;
    _captionItem = widget.subMenu.caption;
    _itemPositionsListener.itemPositions.addListener(_positionListener);
  }

  void refresh() {
    if (widget.subMenu.itemsBuilder != null) {
      _startVisibleIndex = 0;
      _endVisibleIndex = 0;
      _selectedIndex = 0;
      _visibleItemsCount = widget.subMenu.visibleItemsCount;
      _menuItems = widget.subMenu.itemsBuilder();
      if (mounted) setState(() {});
    }
  }
  
  void _positionListener() {
    final positions = _itemPositionsListener.itemPositions.value;
    if (positions.isNotEmpty) {
      if (positions.first.itemLeadingEdge >= 0 || positions.length == 1) {
        _startVisibleIndex = positions.first.index;
      } else {
        _startVisibleIndex = positions.toList()[1].index;
      }

      if (positions.last.itemTrailingEdge <= 1 || positions.length == 1) {
        _endVisibleIndex = positions.last.index;
      } else {
        _endVisibleIndex = positions.toList()[positions.length - 2].index;
      }
    } else {
      _startVisibleIndex = 0;
      _endVisibleIndex = 0;
    }
  }

  void _initValues() {
    _startVisibleIndex = 0;
    _endVisibleIndex = 0;
    _visibleItemsCount = widget.subMenu.visibleItemsCount;
    _menuItems = widget.subMenu.items;
    _captionItem = widget.subMenu.caption;
  }

  @override
  void dispose() {
    _itemPositionsListener.itemPositions.removeListener(_positionListener);
    super.dispose();
  }

  // panning to the right on the wheel

  void increaseSelectedIndex(bool haptics) {
    if (_selectedIndex < _menuItems.length - 1) {
      _selectedIndex++;
      if (_endVisibleIndex < _selectedIndex) {
        final int jumpIndex =
            _selectedIndex - (_endVisibleIndex - _startVisibleIndex);
        _scrollController.jumpTo(index: jumpIndex);
      }
      setState(() {});
      if (haptics) {
        HapticFeedback.lightImpact();
        //SystemSound.play(SystemSoundType.click);
      }

    }
  }

  // panning to the left
  void decreaseSelectedIndex(bool haptics) {
    if (_selectedIndex > 0) {
      _selectedIndex--;

      if (_startVisibleIndex > _selectedIndex) {
        _scrollController.jumpTo(index: _selectedIndex);
      }
      setState(() {});
      if (haptics) {
        HapticFeedback.lightImpact();
        //SystemSound.play(SystemSoundType.click);
      }
    }
  }

  AltSubMenu tap() {
    HapticFeedback.mediumImpact();
    //SystemSound.play(SystemSoundType.click);
    final AltMenuItem item = _menuItems[_selectedIndex];
    final VoidCallback tap = item.onTap;
    if (tap != null) tap();
    return item.subMenu;
  }


  @override
  Widget build(BuildContext ctx) {
    return _buildBody();
  }

  Container _buildBody() {
    return Container(
      decoration: widget.decoration,
      child: Column(
        children: <Widget>[
          _captionItem,
          Expanded(
            child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
              final double normalHeight =
                  constraints.maxHeight / _visibleItemsCount;

              return ScrollablePositionedList.builder(
                physics: NeverScrollableScrollPhysics(),
                itemScrollController: _scrollController,
                itemPositionsListener: _itemPositionsListener,
                itemCount: _menuItems.length,
                itemBuilder: (BuildContext context, int index) => 
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 15, 20, 0),
                  child: _buildItem(
                            index: index,
                            height: normalHeight,
                            isSelected: index == _selectedIndex,
                          ),
                )
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildItem({
    @required int index,
    @required double height,
    @required bool isSelected,
    bool isCancelButton = false,
  }) {
    assert(index != null);
    assert(height != null);
    assert(isSelected != null);
    assert(isCancelButton != null);

    final AltMenuItem item = _menuItems[index];

    if(item == _menuItems.last) {
      isCancelButton = true;
    }

    return Container(
      height: 250 / _visibleItemsCount,
      decoration:
          isSelected ? BoxDecoration(
            gradient: widget.selectionColor,
            border: Border.all(color: Colors.white, width: 3),
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ) 
          : BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: isCancelButton ? [Color(0xff383c44), Color(0xff666b73)] : [Color(0xffdddddd), Color(0xfff0f1f3)],
            ),
            border: Border.all(color: Color(0xff3e434b), width: 3),
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
      child: ListTile(
        title: Transform(
                transform: Matrix4.translationValues(0, 0.0, 0.0),
                  child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                  child: Text(item.text, textAlign: TextAlign.center,
                  maxLines: 1,
                  style: isSelected
                      ? widget.selectedItemTextStyle
                      : (isCancelButton ? widget.cancelButtonTextStyle : widget.itemTextStyle)))),
        subtitle: item.subText != null
            ? Transform(
                  transform: Matrix4.translationValues(-10, -5.0, 0.0),
                child: Text(item.subText,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: isSelected
                    ? widget.selectedItemTextStyle
                    : widget.itemTextStyle))
            : null,
        dense: true,
      ),
    );
  }
}
