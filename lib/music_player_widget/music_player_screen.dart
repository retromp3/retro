import 'dart:async';

/*import 'package:battery_indicator/battery_indicator.dart';
import 'package:battery_plus/battery_plus.dart';*/
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:retro/blocs/player/player_bloc.dart';
import 'package:retro/blocs/player/player_event.dart';
import 'package:retro/blocs/player/player_state.dart';
import 'package:intl/intl.dart';
import 'package:retro/clickwheel/pan_handlers.dart';
import 'package:retro/helpers/marquee.dart';
import 'package:retro/helpers/size_helpers.dart';
import 'package:retro/music_models/playback_state/playback_state_model.dart';
import 'package:retro/resources/resources.dart';
import 'package:percent_indicator/percent_indicator.dart';


class NowPlayingScreen extends StatefulWidget {

  const NowPlayingScreen({Key? key})
      : super(key: key);

  @override
  _NowPlayingScreenState createState() => _NowPlayingScreenState();
}

class _NowPlayingScreenState extends State<NowPlayingScreen> {
  StreamSubscription? _subscription;
  Timer? _timer;
  Timer? _altTime;
  bool _showTime = false;

  late String _timeString;

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('h:mm a').format(dateTime);
  }

  @override
  void initState() {
    super.initState();
    _subscription =
        Stream.periodic(Duration(milliseconds: 1000)).listen((event) {
      BlocProvider.of<PlayerBloc>(context).add(NowPlayingFetched());
    });

    _altTime = Timer.periodic(Duration(seconds: 10), (Timer t) {
      setState(() {
        _showTime = !_showTime;
      });
    });

    _timeString = _formatDateTime(DateTime.now());
    Timer.periodic(Duration(milliseconds: 1000), (Timer t) => _getTime());
    
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _timer?.cancel();
    _altTime?.cancel();
    super.dispose();
  }

  // display the current time
  void _getTime() {
    DateTime _now = DateTime.now();
    final String formattedDateTime = _formatDateTime(_now);
    if (this.mounted) {
      setState(() {
        _timeString = formattedDateTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
      ),
      child: SingleChildScrollView(child:Column(
          children: <Widget>[
            _statusBar(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Stack(
                  children: [
                    Column(
                      children: [
                        SizedBox(height: 20.0),
                        _albumArt(mediaQuery),
                      ],
                    ),
                    
                    Column(
                      children: [
                        SizedBox(height: 230.0),
                        AnimatedSwitcher(
                          duration: Duration(milliseconds: 250), // Adjust the duration to suit your needs
                          transitionBuilder: (Widget child, Animation<double> animation) {
                            return FadeTransition(child: child, opacity: animation);
                          },
                          child: isVolume ? _volumeBar() : _linearProgressIndicator(),
                        ),
                      ],
                    ),

                  ],
                ),

            )
          ],
        )),
    );
  }

  Widget _statusBar() {
    return BlocBuilder<PlayerBloc, PlayerState>(
      builder: (BuildContext ctx, PlayerState state) {
        final bool isPlaying = state is NowPlayingState &&
          state.playbackState == PlaybackStateModel.playing;
        return Container(
            height: 25,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (Widget child, Animation<double> animation) {
                      return FadeTransition(child: child, opacity: animation);
                    },
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: _showTime
                          ? Text('Now Playing',
                              key: ValueKey<int>(1),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 14.5))
                          : Text(_timeString,
                              key: ValueKey<int>(2),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 14.5)),
                    ),
                  ),
              Spacer(),
              ShaderMask(
                shaderCallback: (bounds) => RadialGradient(
                  center: Alignment.center,
                  radius: 0.5, // You can adjust this as needed
                  colors: [Colors.lightBlueAccent, Color.fromARGB(255, 45, 141, 220)],
                  tileMode: TileMode.mirror, 
                ).createShader(bounds),
                child: Icon(
                  isPlaying ? SFSymbols.pause_fill : SFSymbols.play_fill,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              SizedBox(width: 5),
              Image.asset(
                'assets/battery/full.png',
                width: 30,
              ),
            ]),
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xFF9A9B9E), Color(0xFFFFFFFF)],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  tileMode: TileMode.clamp),
              ),
          );
      });
  }

  /*Widget _buildBatteryStatus() {
    return Container(
      child: SizedBox(
        child: new Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (_charging)
                Icon(
                    //Icons.bolt,
                    Icons.arrow_right,
                    size: _size,
                    color: Colors.black),
                new BatteryIndicator(
                  style: BatteryIndicatorStyle.values[_styleIndex],
                  colorful: _colorful,
                  showPercentNum: _showPercentNum,
                  mainColor: _color,
                  size: _size,
                  ratio: _ratio,
                  //showPercentSlide: _showPercentSlide,
                ),
              /*if (_charging)
                Icon(
                  Icons.power,
                  size: _size,
                  color: Colors.black
                ),*/
            ],
          ),
        ),
      ),
    );
  }*/

  Widget _linearProgressIndicator() {
    return BlocBuilder<PlayerBloc, PlayerState>(
        builder: (BuildContext ctx, PlayerState state) {
      if (state is NowPlayingState) {
        final double value = state.playBackTime! / state.songInfo!.duration;
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
               child: Text(
                getHumanTime(state.playBackTime!),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 13.0),
                )
            ),
            Column(children: [ 
              Stack(children: [
                Transform(
                  transform: Matrix4.translationValues(10, 0, 0),
                  child: SizedBox(
                  height: 17,
                  width: displayWidth(context) * 0.595,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(color: Color.fromARGB(255, 214, 214, 214), width: 0.5), // Color and width for top border
                          bottom: BorderSide(color: Color.fromARGB(255, 199, 199, 199), width: 0.5), // Color and width for bottom border
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: [0.0, 0.4, 1.0],
                          colors: <Color>[Color.fromARGB(255, 255, 255, 255),Color.fromARGB(255, 239, 239, 239), Color.fromARGB(255, 208, 208, 208)],  // Specify your color list here
                        ),
                      ),
                    ),
              ),
                ),
              SizedBox(
                height: 17,
                width: displayWidth(context) * 0.65,
                child: LinearPercentIndicator(
                        clipLinearGradient: false,
                        lineHeight: 24,
                        
                        percent: value,
                        linearGradient: LinearGradient(
                          stops: [0.0, 0.4, 1.0],
                            colors: [
                              Color(0xFF91B7F1),
                              Color.fromARGB(255, 51, 136, 255),
                              Color(0xFF96DFFC),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          backgroundColor: Colors.transparent,
                      )
              )

              ],),
              
              Opacity(
                opacity: 0.1,
                child: SizedBox(
                height: 10,
                width: displayWidth(context) * 0.65,
                child: LinearPercentIndicator(
                  clipLinearGradient: true,
                  lineHeight: 10,
                  backgroundColor: Colors.grey[100],
                  percent: value,
                  linearGradient: LinearGradient(
                    stops: [0.0, 0.4, 1.0],
                      colors: [
                        Color(0xFF91B7F1),
                        Color(0xff7DB1F8),
                        Color(0xFF96DFFC),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                )
              ),
              )
            ],),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Text(
              getHumanTime(state.songInfo!.duration),
              style: TextStyle(
                //fontFamily: "Calibre-Semibold",
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 13.0,
              ),
            ),
            )
          ],
        );
        
      }
      return Container();
    });
  }


  Widget _volumeBar() {
    return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
               child: Icon(Icons.volume_mute_rounded, color: Color.fromARGB(255, 89, 89, 89), size: 20),
            ),
            Column(children: [ 
              Stack(children: [
                Transform(
                  transform: Matrix4.translationValues(10, 0, 0),
                  child: SizedBox(
                  height: 17,
                  width: displayWidth(context) * 0.595,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(color: Color.fromARGB(255, 214, 214, 214), width: 0.5), // Color and width for top border
                          bottom: BorderSide(color: Color.fromARGB(255, 199, 199, 199), width: 0.5), // Color and width for bottom border
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: [0.0, 0.4, 1.0],
                          colors: <Color>[Color.fromARGB(255, 255, 255, 255),Color.fromARGB(255, 239, 239, 239), Color.fromARGB(255, 208, 208, 208)],  // Specify your color list here
                        ),
                      ),
                    ),
              ),
                ),
              SizedBox(
                height: 17,
                width: displayWidth(context) * 0.65,
                child: TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0, end: volume),
                  duration: Duration(milliseconds: 1500),
                  builder: (BuildContext context, double percent, Widget? child) {
                    return LinearPercentIndicator(
                      clipLinearGradient: false,
                      lineHeight: 24,
                      percent: volume,
                      linearGradient: LinearGradient(
                        stops: [0.0, 0.4, 1.0],
                        colors: [
                          Color(0xFF91B7F1),
                          Color.fromARGB(255, 51, 136, 255),
                          Color(0xFF96DFFC),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      backgroundColor: Colors.transparent,
                    );
                  },
                ),
              )

              ],),
              
              Opacity(
                opacity: 0.1,
                child: SizedBox(
                height: 10,
                width: displayWidth(context) * 0.65,
                child: TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0, end: volume),
                  duration: Duration(milliseconds: 1500),
                  builder: (BuildContext context, double percent, Widget? child) {
                    return LinearPercentIndicator(
                      clipLinearGradient: false,
                      lineHeight: 24,
                      percent: volume,
                      linearGradient: LinearGradient(
                        stops: [0.0, 0.4, 1.0],
                        colors: [
                          Color(0xFF91B7F1),
                          Color.fromARGB(255, 51, 136, 255),
                          Color(0xFF96DFFC),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      backgroundColor: Colors.transparent,
                    );
                  },
                ),
              ),
              )
            ],),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Icon(Icons.volume_up_rounded, color: Color.fromARGB(255, 89, 89, 89), size: 20)
            )
          ],
        );
  }


  Widget _albumArt(MediaQueryData mediaQuery) {
    
    return BlocBuilder<PlayerBloc, PlayerState>(
        buildWhen: (PlayerState prev, PlayerState cur) =>
            (prev is NowPlayingState &&
                cur is NowPlayingState &&
                prev.songInfo!.coverArt != cur.songInfo!.coverArt) ||
            (!(prev is NowPlayingState && cur is NowPlayingState)),
        builder: (BuildContext ctx, PlayerState state) {
          
          if (state is NowPlayingState) {
            return Center(
              child: Row(
                children: <Widget>[
                  Transform(
                    //alignment: Alignment(0, -1),
                    transform: Matrix4.identity()
                              ..setEntry(3, 2, 0.005) //0.0003
                              ..rotateY(-0.3)//0.3
                              ..scale(0.9, 0.9),
                    alignment: Alignment(0, -0.5 ),
                    child: Column(children: [
                     Container(
                          width: mediaQuery.size.width / 2.3,
                          height: mediaQuery.size.width / 2.3,
                          child: state.songInfo!.coverArt ?? FittedBox(),
                        ),
                      Transform(
                        transform: Matrix4.identity()..scale(1.0, -1.0),
                        alignment: FractionalOffset.center,
                        child: Opacity(
                          opacity: 0.5,
                          child: ShaderMask(
                              shaderCallback: (rect) {
                                return LinearGradient(
                                  begin: Alignment(0,100),
                                  end: Alignment.topCenter,
                                  colors: [Color.fromARGB(121, 0, 0, 0),  Colors.transparent],
                                ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height / 20));
                              },
                              blendMode: BlendMode.dstIn,
                              child: Container(
                                width: mediaQuery.size.width / 2.3,
                                height: mediaQuery.size.width / 2.3,
                                child: state.songInfo!.coverArt ?? FittedBox(),
                              ),
                            ),
                        ),
                      ),

                    
                    ]
                    )
                  ),
                    
                  Expanded(
                    flex: 2,
                    child: Container(
                      margin: EdgeInsets.only(bottom: 140),
                      child: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child:  Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Align(
                              alignment: Alignment.topLeft,
                              child: MarqueeWidget(
                                  direction: Axis.horizontal,
                                  child: Text(
                                    state.songInfo!.title, 
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Heros'
                    
                                    )
                                  )
                                ),
                            ),
                            SizedBox(height: 5.0),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                state.songInfo!.artistName!,
                                style: TextStyle(
                                  color: Color.fromARGB(255, 106, 106, 106),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  //fontFamily: 'Heros'
                                ),
                              ),
                            ),
                            SizedBox(height: 5.0),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: MarqueeWidget(
                                  direction: Axis.horizontal,
                                  child: Text(
                                    state.songInfo!.albumTitle!,
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 106, 106, 106),
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                    
                                    )
                                  )
                                ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return Container();
        });
  }
}
