import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playify/playify.dart';
import 'package:retro/blocs/player/player_bloc.dart';
import 'package:retro/blocs/songs/song_list.dart';
import 'package:retro/blocs/theme/theme.dart';
import 'package:retro/ipod.dart';
import 'package:retro/ipod_menu_widget/ipod_menu_widget.dart';
import 'package:retro/resources/main_player_repository.dart';

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
GlobalKey<IPodMenuWidgetState> menuKey = new GlobalKey<IPodMenuWidgetState>();
IPodSubMenu menu;
List<String> songIDs;
MainViewMode mainViewMode;

enum MainViewMode {menu, player}

void main() => runApp(MyApp(playify: Playify()));

class MyApp extends StatelessWidget {
  final Playify playify;

  const MyApp({Key key, this.playify}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    return MaterialApp(
      theme: ThemeData(brightness: Brightness.dark),
      debugShowCheckedModeBanner: false,
      home: MultiBlocProvider(
        providers: [
          BlocProvider<ThemeBloc>(create: (ctx) => ThemeBloc()),
          BlocProvider<SongListBloc>(
            lazy: false,
            create: (ctx) => SongListBloc(MainPlayerRepository())
              ..add(SongListPreferencesFetched()),
          ),
          BlocProvider<PlayerBloc>(
            lazy: false,
            create: (ctx) => PlayerBloc(MainPlayerRepository()),
          )
        ],
        child: _buildBody()
      )
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