/*
  
  The actual iPod menu. List of all the menus/sub-menus, songs, tap functionality, etc.

*/
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:holding_gesture/holding_gesture.dart';
import 'package:perfect_volume_control/perfect_volume_control.dart';
import 'package:playify/playify.dart';
import 'package:retro/alt_menu/alt_menu_item.dart';
import 'package:retro/alt_menu/alt_sub_menu.dart';
import 'package:retro/alt_menu/alt_menu_design.dart';
import 'package:retro/blocs/player/player_bloc.dart';
import 'package:retro/blocs/player/player_event.dart';
import 'package:retro/blocs/songs/song_list.dart';
import 'package:retro/blocs/theme/theme_bloc.dart';
import 'package:retro/blocs/theme/theme_event.dart';
import 'package:retro/blocs/theme/theme_state.dart';
import 'package:retro/coverflow/covercycle.dart';
import 'package:retro/helpers/size_helpers.dart';
import 'package:retro/ipod_menu_widget/ipod_menu_item.dart';
import 'package:retro/ipod_menu_widget/ipod_sub_menu.dart';
import 'package:retro/main.dart';
import 'package:retro/menu.dart';
import 'package:retro/music_models/apple_music/artist/artist_model.dart';
import 'package:retro/music_models/apple_music/song/song_model.dart';
import 'package:retro/music_models/playlist/playlist_model.dart';
import 'package:retro/music_player_widget/music_player_screen.dart';
import 'package:audio_session/audio_session.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:url_launcher/url_launcher.dart';

import 'clickwheel/pan_handlers.dart';
import 'clickwheel/wheel_content.dart';
import 'games/breakout/breakout.dart';
import 'ipod_menu_widget/menu_design.dart';

class IPod extends StatefulWidget {
  final List<Song>? songs;

  IPod({Key? key, this.songs}) : super(key: key);
  

  @override
  IPodState createState() => IPodState();
}

class IPodState extends State<IPod> {
  final _channel = const MethodChannel("co.retromusic.app");
  bool fetchingAllSongs = false;
  bool playing = false;
  SongInformation? data;
  Shuffle shufflemode = Shuffle.off;
  Repeat repeatmode = Repeat.none;
  var myplayer = Playify();
  List<Artist> artists = [];
  double time = 0.0;
  double volume = 0.0;
  List<String> genres = [];
  String selectedGenre = "";
  List<SongModel>? _songs;
  List<ArtistModel>? _artists;
  List<PlaylistModel>? _playlists;
  bool debugMenu = false;
  PageController? _pageController;
  bool isCoverCycleVisible = true;
  bool isNestedMenu = false;
  final Uri _discord = Uri.parse('https://discord.retromusic.co');
  final Uri _twitter = Uri.parse('https://twitter.com/retro_mp3');
  final Uri _kofi = Uri.parse('https://ko-fi.com/retromp3');
  final Uri _github = Uri.parse('https://github.com/retromp3/retro');

  final PageController _pageCtrl = PageController(viewportFraction: 0.6);

  double? currentPage = 0.0;
  
  @override
  void initState() {
    mainViewMode = MainViewMode.menu;
    menu = getIPodMenu();
    altMenu = getAltMenu(context);
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
    songIDs = [];
    _playlists = [];
    _pageController = PageController(initialPage: 0);

    PerfectVolumeControl.hideUI = true;
    

    _channel.setMethodCallHandler((call) async {
      final methodName = call.method;
      switch (methodName) {
        case "nextSongFromWatch":
          musicControls.playNextSong(context);
          return;
        case "prevSongFromWatch":
          musicControls.playPrevSong(context);
          return;
        /*case "increaseVolumeFromWatch":
          musicControls.increaseVolume();
          return;
        case "decreaseVolumeFromWatch":
          musicControls.increaseVolume();
          return;*/
        default:
          return;
      }
    });

    _pageCtrl.addListener(() {
      setState(() {
        currentPage = _pageCtrl.page;
      });
    });
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
       homePressed(context);
    });
  }

  

  Widget buildMainView() {
    switch (mainViewMode) {
      case MainViewMode.menu:
        return buildMenu();
      case MainViewMode.player:
        return NowPlayingScreen();
      case MainViewMode.breakoutGame:
        return BreakoutGame(key: breakoutGame);
        break;
    }
    return FittedBox();
  }

  _launchDiscord() async {
    if (!await launchUrl(_discord)) {
      throw Exception('Could not launch $_discord');
    }
  }

  _launchTwitter() async {
    if (!await launchUrl(_twitter)) {
      throw Exception('Could not launch $_twitter');
    }
  }

  _launchKofi() async {
    if (!await launchUrl(_kofi)) {
      throw Exception('Could not launch $_kofi');
    }
  }

  _launchGithub() async {
    if (!await launchUrl(_github)) {
      throw Exception('Could not launch $_github');
    }
  }
  
  

  // sends the user back to the menu
  void homePressed(context) {
    setState(() => mainViewMode = MainViewMode.menu);
  }

  // sends the user to the player
  void showPlayer() {
    _pageController!.animateToPage(1, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
    setState(() {
      mainViewMode = MainViewMode.player;
    });
  }

  // sends the user to Breakout
  void showBreakoutGame() {
     _pageController!.animateToPage(2, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
    setState(() {
      mainViewMode = MainViewMode.breakoutGame;
    });
  }

  void _showDialog(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text("Apple Music is currently not supported."),
        content: Text("Follow @retro_mp3 on Twitter/X for updates."),
        actions: <Widget>[
          CupertinoDialogAction(
            child: Text("Close"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  void shuffleSongs(context) {
    BlocProvider.of<PlayerBloc>(context).add(ShuffleCalled());
  }

  List<IPodMenuItem> allSongs() {
    List<IPodMenuItem> combineSongs = [];
    List<IPodMenuItem> allPlaylists = _playlistBuilder();
    List<IPodMenuItem> songsInPlaylist = _songsInEachPlaylist();

    for(var i = 0; i < allPlaylists.length; i++) {
      combineSongs.add(allPlaylists[i]);
      for(var j = 0; j < songsInPlaylist.length; j++) {
        combineSongs.add(songsInPlaylist[j]);
      }
    }

    if (_songs == null || _songs!.isEmpty) {
      return [IPodMenuItem(text: 'No songs fetched')];
    }
    List<SongModel> sortedSongs = List.from(_songs!)..sort((a, b) => a.title!.compareTo(b.title!));
    
    for(var i = 0; i < sortedSongs.length; i++) {
      combineSongs.add(IPodMenuItem(
            text: '${sortedSongs[i].title}',
            subText: '${sortedSongs[i].artistName}',
            onTap: () => BlocProvider.of<PlayerBloc>(context)
                .add(SetQueueItem(sortedSongs[i].songID)),
          ));
    }
    return combineSongs; //can't return null
  }
  
  List<IPodMenuItem> _songListBuilder() {
    if (_songs == null || _songs!.isEmpty) {
      return [IPodMenuItem(text: 'No songs fetched')];
    }

    List<SongModel> sortedSongs = List.from(_songs!)..sort((a, b) => a.title!.compareTo(b.title!));

    return sortedSongs
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


  List<IPodMenuItem> _songsInEachPlaylist() {

    final List<IPodMenuItem> items = _songs!
        .map(
          (SongModel song) => IPodMenuItem(
            //img: Image.memory(song.coverArtBytes),
            text: '${song.title}',
            subText: '${song.artistName}',
            onTap: () => BlocProvider.of<PlayerBloc>(context)
                .add(SetQueueItem(song.songID)),
          ),
        )
        .toList();

    return items;
  }

  List<IPodMenuItem> _playlistBuilder() {
    if (_playlists == null || _playlists!.isEmpty) {
      return [IPodMenuItem(text: 'No playlists fetched')];
    }
    final IPodSubMenu songsInPlaylistMenu =  IPodSubMenu(
      caption: MenuCaption(text: "Songs"),
      itemsBuilder: _songsInEachPlaylist,
    );
    return _playlists!
        .map(
          (PlaylistModel playlist) => IPodMenuItem(
            text: '${playlist.name}',
            subMenu: songsInPlaylistMenu,
            onTap: () {
              BlocProvider.of<SongListBloc>(context)
                .add(SongListFetched(playlist.id));
              
              setState(() {
                isCoverCycleVisible = false;
              });
            }
          ),
        )
        .toList();
  }

  void _songStateListener(BuildContext context, SongListState state) {
    if (state is SongListFetchSuccess) {
      _songs = state.songList;
      _artists = state.artistsList;
      songIDs = state.songList.map((SongModel song) => song.songID).toList();
      _playlists = state.playlists;
       menuKey?.currentState?.refresh();
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
                height: displayHeight(context) * 0.8,
                width: displayWidth(context) * 0.96,
                decoration: new BoxDecoration(
                  color: const Color(0xFF1c1c1c),
                  borderRadius: BorderRadius.all(
                    Radius.circular(8),
                  ),
                ),
                child: Stack(
                  children: [
                    
                    Padding(
                      padding: EdgeInsets.all(5.8),
                      child: Stack(
                        children: <Widget>[

                          // Position CoverCycle on the right half of the screen
                          AnimatedPositioned(
                            curve: Curves.easeIn,
                            duration: const Duration(milliseconds: 200),
                            right: isCoverCycleVisible ? 0 : -MediaQuery.of(context).size.width / 2.15,
                            top: 0,
                            bottom: 0,
                            width: displayWidth(context) / 2.15,
                            child: AnimatedOpacity(
                              opacity: isCoverCycleVisible ? 1.0 : 0.0,
                              duration: const Duration(milliseconds: 200),
                              child: CoverCycle(autoScroll: true),
                            ),
                          ),
                          // Your PageView goes here
                          PageView(
                            controller: _pageController,
                            children: <Widget>[
                              FractionallySizedBox(
                                widthFactor: isCoverCycleVisible ? 0.5 : 1.0, 
                                alignment: Alignment.centerLeft,
                                child: buildMenu(),
                              ),
                              NowPlayingScreen(),
                              BreakoutGame(key: breakoutGame),
                            ],
                          ),

                          AnimatedPositioned(
                            curve: Curves.easeIn,
                            duration: const Duration(milliseconds: 200),
                            right: isCoverCycleVisible ? 0 : -MediaQuery.of(context).size.width / 2.15,
                            top: 0,
                            bottom: 0,
                            width: displayWidth(context) / 2.15,
                            child: AnimatedOpacity(
                              opacity: isCoverCycleVisible ? 1.0 : 0.0,
                              duration: const Duration(milliseconds: 250),
                              child: CoverCycle(autoScroll: true),
                            ),
                          ),
                        ],
                      ),
                    ),

                   
                  Padding(
                    padding: EdgeInsets.all(5.5), 
                      child: AnimatedOpacity(
                        opacity: popUp ? 1.0 : 0.0,
                        duration: Duration(milliseconds: 200),
                        child: Container(color: Colors.black.withOpacity(0.5)),
                      ),
                    ),
                  altIpodMenu(context),
                ])
                ),
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

  /* technically this should be in wheel_content.dart but for some reason it doesn't work when its there lol */
  Widget menuButton(context) {
    return InkWell(
      onTap: () async {
        if(mainViewMode != MainViewMode.menu) {
          homePressed(context);
          _pageController!.animateToPage(0, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
        }
        if(mainViewMode == MainViewMode.player) {
          setState(() {
              isCoverCycleVisible = true;
            });
        }
        else if(popUp == true) {
          setState(() {
            popUp = false;
          });
        }
        else {
          
          menuKey.currentState?.back();
          _pageController!.animateToPage(0, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
          
          if(isCoverCycleVisible == false /*&& isNestedMenu == true*/) {
            setState(() {
              isCoverCycleVisible = true;
            });
          }

          /*if(isCoverCycleVisible == false && isNestedMenu == false) {
            setState(() {
              isCoverCycleVisible = true;
            });
          }*/
        }
        HapticFeedback.mediumImpact();
        await Future.delayed(Duration(milliseconds: 100));
          HapticFeedback.lightImpact();
        
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

  Widget clickWheel(BuildContext context, ThemeState state) {
    wheelColor = state.wheelColor == WheelColor.black
        ? Color.fromARGB(255, 36, 36, 37)
        : Colors.white;
        
 
    controlsColor = state.wheelColor == WheelColor.white
        ? Color.fromARGB(255, 185, 185, 190)
        : Color.fromARGB(255, 222, 222, 222);
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          GestureDetector(
            onPanUpdate: panUpdateHandler,
            onPanStart: panStartHandler,
            child: Container(
              height: displayWidth(context) * 0.77,
              width: displayWidth(context) * 0.77,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Color.fromARGB(255, 95, 95, 95), width: 0.5),
                color: wheelColor,
              ),
              child: Stack(children: [
                menuButton(context),
                fastRewind(context),
                fastForward(context),
                playButton(context)
              ]),
            ),
          ),
          GestureDetector(
            onTap: () async {
              if(mainViewMode == MainViewMode.breakoutGame){
                if(breakoutGame.currentState?.isBreakoutGameOver == true && breakoutGame.currentState?.gameState == Game.fail){
                  breakoutGame.currentState?.restart();
                }
              }
              else if(popUp == true) {
                altMenuKey?.currentState?.select();
              }
              else {
                menuKey?.currentState?.select();
              }
              HapticFeedback.mediumImpact();
              await Future.delayed(Duration(milliseconds: 100));
              HapticFeedback.lightImpact();
            },
            child: selectButton()
          ),
        ],
      ),
    );
  }

  AltSubMenu getAltMenu(context) {
    return AltSubMenu(
      items: [
        AltMenuItem(
          text: 'Spotify',
          onTap: () {
              BlocProvider.of<SongListBloc>(context).add(SpotifyConnected());
          }
        ),
        AltMenuItem(
          text: 'Apple Music',
          onTap: () {
              _showDialog(context);
          }
        ),
        AltMenuItem(
          text: 'Cancel',
          onTap:() => setState(() {
                popUp = false;
          }),
        ),
        
      ],
    );
  }

  AltSubMenu getAltMenu2(context) {
    return AltSubMenu(
      items: [
        AltMenuItem(
          text: 'bro',
          onTap: () {
              
          }
        ),
        AltMenuItem(
          text: 'Apple Music',
        ),
        AltMenuItem(
          text: 'Cancel',
          onTap:() => setState(() {
                popUp = false;
          }),
        ),
        
      ],
    );
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
      ],
    );

    final IPodSubMenu presetsMenu = IPodSubMenu(
      caption: MenuCaption(text: "Presets"),
      items: <IPodMenuItem>[
        IPodMenuItem(
          text: "Space Gray",
          onTap: () {
            BlocProvider.of<ThemeBloc>(context).add(
              SkinThemeChanged(SkinTheme.black),
            );
            BlocProvider.of<ThemeBloc>(context).add(
              WheelColorChanged(WheelColor.black),
            );
          }
        ),
        IPodMenuItem(
          text: "Silver",
          onTap: () {
            BlocProvider.of<ThemeBloc>(context).add(
              SkinThemeChanged(SkinTheme.silver),
            );
            BlocProvider.of<ThemeBloc>(context).add(
              WheelColorChanged(WheelColor.white),
            );
          }
        ),
      ],
    );

    final IPodSubMenu themeMenu = IPodSubMenu(
      caption: MenuCaption(text: "Theme"),
      items: <IPodMenuItem>[
        IPodMenuItem(text: "Presets", subMenu: presetsMenu),
        //IPodMenuItem(text: "Wheel", subMenu: wheelMenu),
      ],
    );

    final IPodSubMenu songs = IPodSubMenu(
      caption: MenuCaption(text: "Songs"),
      items: <IPodMenuItem>[],
      itemsBuilder: _songListBuilder
    );



    // Music Menu

    final IPodSubMenu playlistMenu = IPodSubMenu(
      caption: MenuCaption(text: "Playlists"),
      itemsBuilder: _playlistBuilder,
    );


    final IPodSubMenu musicMenu = IPodSubMenu(
      caption: MenuCaption(text: "Music"),
      items: <IPodMenuItem>[
        IPodMenuItem(text: "Sign In",
          onTap:() => setState(() {
                popUp = true;
          }),),
        IPodMenuItem(text: "Songs", subMenu: songs,
          onTap: () => setState(() {
                isCoverCycleVisible = false;
          }),
        ),
        IPodMenuItem(
          text: "Playlists", 
          subMenu: playlistMenu,
          onTap: () => setState(() {
                isCoverCycleVisible = false;
          }),
        ),
      ],
    );

    // Games Menu

    final IPodSubMenu gamesMenu = IPodSubMenu(
      caption: MenuCaption(text: "Games"),
      items: <IPodMenuItem>[
        IPodMenuItem(
          text: "Breakout", 
          onTap: () {
            showBreakoutGame();
            setState(() {
              isCoverCycleVisible = false;
          
            });
         }),
      ],
    );

    final IPodSubMenu extrasMenu = IPodSubMenu(
      caption: MenuCaption(text: "Extras"),
      items: <IPodMenuItem>[
        IPodMenuItem(text: "Games", subMenu: gamesMenu),
      ],
    );

    /*final IPodSubMenu resetMenu = IPodSubMenu(
      caption: MenuCaption(text: "Reset"),
      items: <IPodMenuItem>[
        IPodMenuItem(text: "Reset All Settings", onTap: () {Phoenix.rebirth(context);}),
      ],
    );*/

     final IPodSubMenu socialsMenu = IPodSubMenu(
      caption: MenuCaption(text: "About"),
      items: <IPodMenuItem>[
        IPodMenuItem(text: "Discord", onTap: () => _launchDiscord()),
        IPodMenuItem(text: "Twitter", onTap: () => _launchTwitter()),
        IPodMenuItem(text: "Ko-Fi", onTap: () => _launchKofi(),),
        IPodMenuItem(text: "Github", onTap: () => _launchGithub(),)
      ],
    );

    final IPodSubMenu settingsMenu = IPodSubMenu(
      caption: MenuCaption(text: "Settings"),
      items: <IPodMenuItem>[
        IPodMenuItem(text: "Themes", subMenu: themeMenu),
        IPodMenuItem(text: "About", subMenu: socialsMenu),
        //IPodMenuItem(text: "Themes", subMenu: themeMenu),
        //IPodMenuItem(text: "Reset", /*onTap: () => Phoenix.rebirth(context),*/),
      ],
    );

    final IPodSubMenu menu = IPodSubMenu(
      caption: MenuCaption(text: "Retro"),
      items: <IPodMenuItem>[
        IPodMenuItem(
          text: "Now Playing", 
          onTap: () {
            showPlayer();
            setState(() {
              isCoverCycleVisible = false;
            });
          }
        ),
        IPodMenuItem(text: "Music", subMenu: musicMenu),
        IPodMenuItem(text: "Playlists",
          subMenu: playlistMenu,
          onTap: () {
            setState(() {
              isCoverCycleVisible = false;
            });
          }
        ),
        IPodMenuItem(text: "Shuffle Songs",
          onTap: () {
            //musicControls.shuffleSongs(context);

          }
        ),
        IPodMenuItem(text: "Extras", subMenu: extrasMenu),
        IPodMenuItem(text: "Settings", subMenu: settingsMenu),
        //if (debugMenu) IPodMenuItem(text: "useless scroll list", subMenu: testMenu),
      ],
    );

    return menu;
  }
}
