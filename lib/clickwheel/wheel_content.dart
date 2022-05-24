import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:retro/appearance/inner_shadow.dart';
import 'package:retro/appearance/skins.dart';
import 'package:retro/blocs/theme/theme_bloc.dart';
import 'package:retro/blocs/theme/theme_state.dart';
import 'package:retro/clickwheel/wheel.dart';
import 'package:retro/main.dart';
import 'package:retro/helpers/size_helpers.dart';

Widget menuButton() {
  return InkWell(
    onTap: () {
      menuKey?.currentState?.back();
    },
    child: Container(
      child: Text(
        'MENU',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: controlsColor,
        ),
      ),
      alignment: Alignment.topCenter,
      margin: EdgeInsets.only(top: 15),
    ),
  );
}

Widget fastForward() {
  return Container(
    child: IconButton(
        icon: Icon(
          SFSymbols.forward_end_alt_fill,
          color: controlsColor,
        ),
        iconSize: 25,
        onPressed: () async {
          HapticFeedback.mediumImpact();
        }),
    alignment: Alignment.centerRight,
    //margin: EdgeInsets.only(right: 30),
  );
}

Widget fastRewind() {
  return Container(
    child: IconButton(
        icon: Icon(
          SFSymbols.backward_end_alt_fill,
          color: controlsColor,
        ),
        iconSize: 25,
        onPressed: () async {
          HapticFeedback.mediumImpact();
        }),
    alignment: Alignment.centerLeft,
    //margin: EdgeInsets.only(left: 30),
  );
}

Widget playButton() {
  return Container(
    child: 
      IconButton(
        icon: Icon(
          SFSymbols.playpause_fill,
          size: 25,
          color: controlsColor,
        ),
          onPressed: () async {
            /*setState(() {
              playing = true;
            });*/
            HapticFeedback.mediumImpact();
          },
      ),
    alignment: Alignment.bottomCenter,
    margin: EdgeInsets.only(bottom: 5),
  );
}

Widget selectButton() {
  return BlocBuilder<ThemeBloc, ThemeState>(
    buildWhen: (ThemeState prev, ThemeState cur) =>
        prev.skinTheme != cur.skinTheme,
    builder: (BuildContext context, ThemeState state) {
      return InnerShadow(
        blur: 2,
        color: const Color(0xff707070),
        offset: const Offset(0, 0),
        child: Container(
          constraints: BoxConstraints(maxWidth: 120, maxHeight: 120),
          width: displayWidth(context) * 0.25,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(getSkin(state)),
              fit: BoxFit.none,
            ),
            shape: BoxShape.circle, 
          ),
      ));
    },
  );
}