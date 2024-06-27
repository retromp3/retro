import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:playify/playify.dart';
import 'package:retro/alt_menu/alt_sub_menu.dart';
import 'package:retro/blocs/player/player_bloc.dart';
import 'package:retro/blocs/songs/song_list.dart';
import 'package:retro/blocs/theme/theme.dart';
// Import this
import 'package:retro/core.dart';
import 'package:retro/ipod_menu_widget/ipod_menu_widget.dart';
import 'package:retro/onboarding/walkthrough.dart';
import 'package:retro/resources/main_player_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'alt_menu/alt_menu_widget.dart';
import 'games/breakout/breakout.dart';
import 'ipod_menu_widget/ipod_sub_menu.dart';

import 'package:retro/appearance/skins.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

late double widgetSize;
late double halfSize;
late double cartesianStartX;
late double cartesianStartY;
late double cartesianStartRadius;
late int ticksPerCircle;
late double tickAngel;
bool? wasExtraRadius;
Color? wheelColor;
Color? controlsColor;
GlobalKey<IPodMenuWidgetState> menuKey = new GlobalKey<IPodMenuWidgetState>();
GlobalKey<AltMenuWidgetState> altMenuKey = new GlobalKey<AltMenuWidgetState>();
GlobalKey<BreakoutGameState> breakoutGame = GlobalKey();
bool popUp = false;
bool showPlayerScreen = false;
late IPodSubMenu menu;
late AltSubMenu altMenu;
List<String?>? songIDs;
MainViewMode? mainViewMode;

enum MainViewMode { menu, player, breakoutGame }

Future<void> main() async {
  await dotenv.load();
  runApp(Phoenix(
    child: MyApp(playify: Playify()),
  ));
}

class MyApp extends StatelessWidget {
  final Playify? playify;

  const MyApp({Key? key, this.playify}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    return MaterialApp(
      theme: ThemeData(brightness: Brightness.dark),
      debugShowCheckedModeBanner: false,
      home: CheckFirstTime(),
    );
  }
}

class CheckFirstTime extends StatefulWidget {
  @override
  _CheckFirstTimeState createState() => _CheckFirstTimeState();
}

class _CheckFirstTimeState extends State<CheckFirstTime> {
  late bool isFirstTime;

  @override
  void initState() {
    super.initState();
    checkFirstTime();
  }

  void checkFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isFirstTime = (prefs.getBool('firstTime') ?? true);

    if (isFirstTime) {
      await prefs.setBool('firstTime', false);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => WalkthroughScreen()),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => IPodApp()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(); // Empty container (splash screen while checking)
  }
}

class IPodApp extends StatelessWidget {
  final Playify? playify;

  const IPodApp({Key? key, this.playify}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    return MaterialApp(
      theme: ThemeData(brightness: Brightness.dark),
      debugShowCheckedModeBanner: false,
      home: MultiBlocProvider(
        providers: [
          BlocProvider<ThemeBloc>(
            create: (ctx) => ThemeBloc()..add(PreferencesFetched()), // Dispatch PreferencesFetched event
          ),
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
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return BlocBuilder<ThemeBloc, ThemeState>(
      buildWhen: (ThemeState prev, ThemeState cur) =>
          prev.skinTheme != cur.skinTheme,
      builder: (BuildContext context, ThemeState state) {
        return Scaffold(
          body: Container(
            child: Transform.scale(scale: 0.96, child: IPod()),
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
