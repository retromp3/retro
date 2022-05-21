import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:retro/blocs/theme/theme.dart';
import 'package:retro/ipod.dart';
import 'package:retro/ipod_menu_widget/ipod_menu_widget.dart';

import 'ipod_menu_widget/ipod_sub_menu.dart';

import 'package:retro/appearance/skins.dart';

List images = [
  '',
  '',
  '',
  '',
  '',
  '',
  '',
  '',
  '',
];

double widgetSize;
double halfSize;
double cartesianStartX;
double cartesianStartY;
double cartesianStartRadius;
int ticksPerCircle;
double tickAngel;
bool wasExtraRadius;
GlobalKey<IPodMenuWidgetState> menuKey = GlobalKey();
IPodSubMenu menu;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    return MaterialApp(
      theme: ThemeData(brightness: Brightness.dark),
      debugShowCheckedModeBanner: false,
      home: BlocProvider<ThemeBloc>(
          create: (ctx) => ThemeBloc()..add(PreferencesFetched()), child: _buildBody()),
    );
  }

  Widget _buildBody() {
    return BlocBuilder<ThemeBloc, ThemeState>(
      buildWhen: (ThemeState prev, ThemeState cur) =>
          prev.skinTheme != cur.skinTheme,
      builder: (BuildContext context, ThemeState state) {
        return Scaffold(
          body: Container(
            child: IPod(),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(getSkin(state)),
                fit: BoxFit.fill,
              ),
            ),
          ),
        );
      },
    );
  }
}