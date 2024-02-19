/*
  
  Controls how the menu list looks and handles basic menu animations.

*/

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:retro/ipod_menu_widget/ipod_menu_item.dart';
import 'package:retro/ipod_menu_widget/ipod_sub_menu.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class IPodMenuPageWidget extends StatefulWidget {
  final IPodSubMenu subMenu;
  final LinearGradient selectionColor;
  final Decoration? decoration;
  final bool isAnimated;
  final VoidCallback? onBackAnimationComplete;
  final TextStyle itemTextStyle;
  final TextStyle selectedItemTextStyle;
  final Widget subMenuIcon;
  final Widget selectedSubMenuIcon;

  IPodMenuPageWidget({
    Key? key,
    required IPodSubMenu subMenu,
    LinearGradient? selectionColor,
    this.decoration,
    bool? isAnimated,
    this.onBackAnimationComplete,
    TextStyle? itemTextStyle,
    TextStyle? selectedItemTextStyle,
    Widget? subMenuIcon,
    Widget? selectedSubMenuIcon,
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
        this.isAnimated = isAnimated ?? true,
        this.itemTextStyle = itemTextStyle ??
            TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        this.selectedItemTextStyle = selectedItemTextStyle ??
            TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        this.subMenuIcon =
            subMenuIcon ?? 
              Transform(
                  transform: Matrix4.translationValues(10, 0.0, 0.0),
                  child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.transparent,
                    size: 15,
                  ))),
        this.selectedSubMenuIcon = selectedSubMenuIcon ??
              Transform(
                  transform: Matrix4.translationValues(10, 0.0, 0.0),
                  child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 15,
                  ))),
        super(key: key);

  @override
  IPodMenuPageWidgetState createState() => IPodMenuPageWidgetState();
}

class IPodMenuPageWidgetState extends State<IPodMenuPageWidget>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late int _startVisibleIndex;
  late int _endVisibleIndex;
  late int _visibleItemsCount;
  late bool _backInProgress;
  final ItemScrollController _scrollController = ItemScrollController();
  final ItemPositionsListener _itemPositionsListener =
      ItemPositionsListener.create();

  late List<IPodMenuItem> _menuItems;
  late Widget _captionItem;

  AnimationController? _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _backInProgress = false;
    _initValues();
    _menuItems = widget.subMenu.itemsBuilder != null
        ? widget.subMenu.itemsBuilder!()
        : widget.subMenu.items;
    _captionItem = widget.subMenu.caption;
    _initAnimation();
    _itemPositionsListener.itemPositions.addListener(_positionListener);

    setState(() {
      _backInProgress = false;
    });
  }

  void refresh() {
    if (widget.subMenu.itemsBuilder != null) {
      _startVisibleIndex = 0;
      _endVisibleIndex = 0;
      _selectedIndex = 0;
      _visibleItemsCount = widget.subMenu.visibleItemsCount;
      _menuItems = widget.subMenu.itemsBuilder!();
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

  void _initAnimation() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 170),
    );
    _animation = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(
        parent: _animationController!,
        curve: Curves.linear,
        reverseCurve: Curves.linear,
      ),
    );
    if (widget.isAnimated) {
      _animationController!.forward();
    } else {
      _animationController!.value = 1;
    }
  }

  @override
  void dispose() {
    _itemPositionsListener.itemPositions.removeListener(_positionListener);
    _animationController?.dispose();
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

  IPodSubMenu? tap() {
    HapticFeedback.mediumImpact();
    //SystemSound.play(SystemSoundType.click);
    final IPodMenuItem item = _menuItems[_selectedIndex];
    final VoidCallback? tap = item.onTap;
    if (tap != null) tap();
    return item.subMenu;
  }

  void back() {
    HapticFeedback.mediumImpact();
    //SystemSound.play(SystemSoundType.click);
    if (!_backInProgress && widget.onBackAnimationComplete != null) {
      _backInProgress = true;
      _animationController!.addStatusListener((status) {
        if (status == AnimationStatus.dismissed)
          widget.onBackAnimationComplete!();
      });
    }

    _animationController!.reverse();
  }

  @override
  Widget build(BuildContext ctx) {
    return LayoutBuilder(
      builder: (context, constraints) => AnimatedBuilder(
        animation: _animation,
        builder: (context, child) => Transform.translate(
          offset: Offset(constraints.maxWidth * _animation.value, 0),
          child: child,
        ),
        child: _buildBody(),
      ),
    );
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
                itemBuilder: (BuildContext context, int index) => _buildItem(
                  index: index,
                  height: normalHeight,
                  isSelected: index == _selectedIndex,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildItem({
    required int index,
    required double height,
    required bool isSelected,
  }) {
    assert(index != null);
    assert(height != null);
    assert(isSelected != null);

    final IPodMenuItem item = _menuItems[index];
    final double normalHeight = 160 / _visibleItemsCount;
    final double withSubtext = 280 / _visibleItemsCount;
    return Container(
      height: item.subText != null ? withSubtext : normalHeight,
      decoration:
          isSelected ? BoxDecoration(gradient: widget.selectionColor) : null,
      child: ListTile(
        title: Transform(
                transform: Matrix4.translationValues(-10, 0.0, 0.0),
                  child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
                  child: Text(item.text,
                  maxLines: 1,
                  style: isSelected
                      ? widget.selectedItemTextStyle
                      : widget.itemTextStyle))),
        subtitle: item.subText != null
            ? Transform(
                  transform: Matrix4.translationValues(-10, -5.0, 0.0),
                child: Text(item.subText!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: isSelected
                    ? widget.selectedItemTextStyle
                    : widget.itemTextStyle))
            : null,
        dense: true,
        trailing: item.subMenu != null
            ? (isSelected ? widget.selectedSubMenuIcon : widget.subMenuIcon)
            : FittedBox(),
      ),
    );
  }
}
