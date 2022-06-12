/*
  
  The actual iPod menu. List of all the menus/sub-menus. Tap functionality, etc.

*/
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playify/playify.dart';
import 'package:retro/blocs/player/player_bloc.dart';
import 'package:retro/blocs/player/player_event.dart';
import 'package:retro/blocs/songs/song_list.dart';
import 'package:retro/blocs/theme/theme_bloc.dart';
import 'package:retro/blocs/theme/theme_event.dart';
import 'package:retro/blocs/theme/theme_state.dart';
import 'package:retro/clickwheel/wheel.dart';
import 'package:retro/ipod_menu_widget/ipod_menu_item.dart';
import 'package:retro/ipod_menu_widget/ipod_sub_menu.dart';
import 'package:retro/main.dart';
import 'package:retro/menu.dart';
import 'package:retro/music_models/apple_music/artist/artist_model.dart';
import 'package:retro/music_models/apple_music/song/song_model.dart';
import 'package:retro/music_models/playlist/playlist_model.dart';

import 'ipod_menu_widget/menu_design.dart';

class IPod extends StatefulWidget {
  final List<Song> songs;

  IPod({Key key, this.songs}) : super(key: key);
  

  @override
  _IPodState createState() => _IPodState();
}

class _IPodState extends State<IPod> {
  bool fetchingAllSongs = false;
  bool playing = false;
  SongInformation data;
  Shuffle shufflemode = Shuffle.off;
  Repeat repeatmode = Repeat.none;
  var myplayer = Playify();
  List<Artist> artists = [];
  double time = 0.0;
  double volume = 0.0;
  List<String> genres = [];
  String selectedGenre = "";
  List<SongModel> _songs;
  List<String> _songIDs;
  List<ArtistModel> _artists;
  List<PlaylistModel> _playlists;

  bool debugMenu = false;

  final PageController _pageCtrl = PageController(viewportFraction: 0.6);

  double currentPage = 0.0;
  
  @override
  void initState() {
    menu = getIPodMenu();
    widgetSize = 300.0;
    halfSize = widgetSize / 2;
    cartesianStartX = 1;
    cartesianStartY = 0;
    cartesianStartRadius = 1;
    ticksPerCircle = 20;
    tickAngel = 2 * pi / ticksPerCircle;
    wasExtraRadius = false;
    _songs = [];
    _artists = [];
    _songIDs = [];
    _playlists = [];

    _pageCtrl.addListener(() {
      setState(() {
        currentPage = _pageCtrl.page;
      });
    });
    super.initState();
   // updateInfo();
  }

  List<IPodMenuItem> _songListBuilder() {
    if (_songs == null || _songs.isEmpty) {
      return [IPodMenuItem(text: 'No songs fetched')];
    }
    return _songs
        .map(
          (SongModel song) => IPodMenuItem(
            text: '${song.title}',
            subText: '${song.artistName}',
            onTap: () => BlocProvider.of<PlayerBloc>(context)
                .add(SetQueueItem(song.songID)),
          ),
        )
        .toList();
  }

  List<IPodMenuItem> _playListBuilder() {
    if (_playlists == null || _playlists.isEmpty) {
      return [IPodMenuItem(text: 'No playlist fetched')];
    }
    return _playlists
        .map(
          (PlaylistModel playlist) => IPodMenuItem(
            text: '${playlist.name}',
            onTap: () => BlocProvider.of<SongListBloc>(context)
                .add(SongListFetched(playlist.id)),
          ),
        )
        .toList();
  }

  void _songStateListener(BuildContext context, SongListState state) {
    if (state is SongListFetchSuccess) {
      _songs = state.songList;
      _artists = state.artistsList;
      _songIDs = state.songList.map((SongModel song) => song.songID).toList();
      _playlists = state.playlists;
    }
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return BlocListener<SongListBloc, SongListState>(
      listener: _songStateListener,
      child: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 25, left: 8, right: 8),
              constraints: BoxConstraints(minHeight: 100, maxHeight: 320),
              height: 300,
              //300
              //height: 235,
              width: 385,

              decoration: new BoxDecoration(
                color: const Color(0xFF1c1c1c),
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
              ),

              child: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.all(5.8), child: buildMenu()),
                ],) 
            ),
            /*Container(
                margin: EdgeInsets.only(top: 25),
                height: 300,
                width: 385,
                decoration: new BoxDecoration(
                  color: Colors.black,
                  
                ),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Flexible(child: buildMenu()),


                          // this enables the split screen view, will work on this later
                          /*Expanded(
                            child: PageView(
                              children: <Widget>[
                                MainContent(1),
                              ],
                            ),
                          ),*/
                        ],
                      ),
                    )
                  ],
                )
                ),*/
            Spacer(),
            BlocBuilder<ThemeBloc, ThemeState>(
              buildWhen: (ThemeState prev, ThemeState cur) =>
                  prev.wheelColor != cur.wheelColor,
              builder: clickWheel,
            ),
            Spacer(),
          ],
        ),
      ));
  }


  IPodSubMenu getIPodMenu() {
    final IPodSubMenu wheelMenu = IPodSubMenu(
      caption: MenuCaption(text: "Wheel Color"),
      items: <IPodMenuItem>[
        IPodMenuItem(
          text: "White",
          onTap: () => BlocProvider.of<ThemeBloc>(context).add(
            WheelColorChanged(WheelColor.white),
          ),
        ),
        IPodMenuItem(
          text: "Black",
          onTap: () => BlocProvider.of<ThemeBloc>(context).add(
            WheelColorChanged(WheelColor.black),
          ),
        ),
       /* IPodMenuItem(
          text: "Red",
          onTap: () => BlocProvider.of<ThemeBloc>(context).add(
            WheelColorChanged(WheelColor.red),
          ),
        ),*/
      ],
    );

    final IPodSubMenu skinMenu = IPodSubMenu(
      caption: MenuCaption(text: "Skin"),
      items: <IPodMenuItem>[
        IPodMenuItem(
          text: "Black",
          onTap: () => BlocProvider.of<ThemeBloc>(context).add(
            SkinThemeChanged(SkinTheme.black),
          ),
        ),
        IPodMenuItem(
          text: "Silver",
          onTap: () => BlocProvider.of<ThemeBloc>(context).add(
            SkinThemeChanged(SkinTheme.silver),
          ),
        ),
        //IPodMenuItem(text: "Pewds"),
      ],
    );

    final IPodSubMenu themeMenu = IPodSubMenu(
      caption: MenuCaption(text: "Theme"),
      items: <IPodMenuItem>[
        IPodMenuItem(text: "Skin", subMenu: skinMenu),
        IPodMenuItem(text: "Wheel", subMenu: wheelMenu),
      ],
    );

    final IPodSubMenu linkAccountMenu = IPodSubMenu(
      caption: MenuCaption(text: "Link Account"),
      items: <IPodMenuItem>[
        IPodMenuItem(
            text: "Spotify",
            onTap: () {
              BlocProvider.of<SongListBloc>(context).add(SpotifyConnected());
            }
        ),
        IPodMenuItem(
          text:
              "Apple Music",
        ),
      ],
    );

    final IPodSubMenu songs = IPodSubMenu(
      caption: MenuCaption(text: "Songs"),
      items: <IPodMenuItem>[],
      itemsBuilder: _songListBuilder
    );



    // Music Menu

    final IPodSubMenu musicMenu = IPodSubMenu(
      caption: MenuCaption(text: "Music"),
      items: <IPodMenuItem>[
        IPodMenuItem(text: "Songs", subMenu: songs),
      ],
    );

    // Games Menu

    final IPodSubMenu gamesMenu = IPodSubMenu(
      caption: MenuCaption(text: "Games"),
      items: <IPodMenuItem>[
        IPodMenuItem(text: "Breakout"),
      ],
    );

    final IPodSubMenu extrasMenu = IPodSubMenu(
      caption: MenuCaption(text: "Extras"),
      items: <IPodMenuItem>[
        IPodMenuItem(text: "Games", subMenu: gamesMenu),
      ],
    );

    final IPodSubMenu resetMenu = IPodSubMenu(
      caption: MenuCaption(text: "Reset"),
      items: <IPodMenuItem>[
        IPodMenuItem(text: "Reset All Settings", onTap: () {}),
      ],
    );

    final IPodSubMenu settingsMenu = IPodSubMenu(
      caption: MenuCaption(text: "Settings"),
      items: <IPodMenuItem>[
        IPodMenuItem(text: "Link Account", subMenu: linkAccountMenu),
        IPodMenuItem(text: "Themes", subMenu: themeMenu),
        IPodMenuItem(text: "Reset", subMenu: resetMenu),
      ],
    );

    final IPodSubMenu testMenu = IPodSubMenu(
      caption: MenuCaption(text: "useless scroll list"),
      items: <IPodMenuItem>[
          for (int i = 0; i < 4096; i++) IPodMenuItem(text: i.toString()),
      ],
    );

    final IPodSubMenu playlistMenu = IPodSubMenu(
      caption: MenuCaption(text: "Playlists"),
      itemsBuilder: _playListBuilder,
    );


    final IPodSubMenu menu = IPodSubMenu(
      caption: MenuCaption(text: "Retro"),
      items: <IPodMenuItem>[
        IPodMenuItem(text: "Now Playing"),
        IPodMenuItem(text: "Music", subMenu: musicMenu),
        IPodMenuItem(text: "Playlists", subMenu: playlistMenu),
        IPodMenuItem(text: "Shuffle"),
        IPodMenuItem(text: "Extras", subMenu: extrasMenu),
        IPodMenuItem(text: "Settings", subMenu: settingsMenu),
        if (debugMenu) IPodMenuItem(text: "useless scroll list", subMenu: testMenu),
      ],
    );

    return menu;
  }
}
