import 'dart:async';
import 'dart:math';

import 'package:battery_indicator/battery_indicator.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter/widgets.dart';
import 'package:marquee/marquee.dart';
import 'package:retro/blocs/player/player_bloc.dart';
import 'package:retro/blocs/player/player_event.dart';
import 'package:retro/blocs/player/player_state.dart';
import 'package:intl/intl.dart';
import 'package:retro/helpers/marquee.dart';
import 'package:retro/helpers/size_helpers.dart';
import 'package:retro/resources/resources.dart';
import 'package:percent_indicator/percent_indicator.dart';

class NowPlayingScreen extends StatefulWidget {

  const NowPlayingScreen({Key key})
      : super(key: key);

  @override
  _NowPlayingScreenState createState() => _NowPlayingScreenState();
}

class _NowPlayingScreenState extends State<NowPlayingScreen> {
  StreamSubscription _subscription;
  var _styleIndex = 1;
  var _colorful = true;
  var _showPercentNum = false;
  var _size = 13.0;
  var _ratio = 2.0;
  Color _color = Colors.grey[600];
  Battery battery = new Battery();
  var _charging = false;

  String _timeString;

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

    _timeString = _formatDateTime(DateTime.now());
    Timer.periodic(Duration(milliseconds: 1000), (Timer t) => _getTime());
  }

  @override
  void dispose() {
    _subscription?.cancel();
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
      child: Column(
          children: <Widget>[
            _statusBar(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Stack(
                children: [
                  _albumArt(mediaQuery),
                 /* Positioned(
                    top: 100,
                    left: 0,
                    right: 0,
                    child: _linearProgressIndicator()
                  ),*/
                ],
              ),)
          ],
        ),
    );
  }

  Widget _statusBar() {
    return Container(
        height: 25,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
          Icon(
            Icons.wifi,
            color: Colors.black,
            size: 14.5,
          ),
          Spacer(),
          SizedBox(width: 15),
          Text("$_timeString",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 12.0)),
          Spacer(),
          _buildBatteryStatus()
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
  }

  Widget _buildBatteryStatus() {
    battery.onBatteryStateChanged.listen((onData) {
      var charging = onData == BatteryState.charging;
      this.setState(() {
        _charging = charging;
      });
    });
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
  }

  Widget _linearProgressIndicator() {
    return BlocBuilder<PlayerBloc, PlayerState>(
        builder: (BuildContext ctx, PlayerState state) {
      if (state is NowPlayingState) {
        final double value = state.playBackTime / state.songInfo.duration;
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
               child: Text(
                getHumanTime(state.playBackTime),
                style: TextStyle(
                    //fontFamily: "Calibre-Semibold",
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 12.0),
                )
            ),
            Column(children: [
              SizedBox(
                height: 15,
                width: displayWidth(context) * 0.65,
                child: LinearPercentIndicator(
                  clipLinearGradient: true,
                  lineHeight: 24,
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
              getHumanTime(state.songInfo.duration),
              style: TextStyle(
                //fontFamily: "Calibre-Semibold",
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 12.0,
              ),
            ),
            )
          ],
        );
        
      }
      return Container();
    });
  }

  Widget _albumArt(MediaQueryData mediaQuery) {
    return BlocBuilder<PlayerBloc, PlayerState>(
        buildWhen: (PlayerState prev, PlayerState cur) =>
            (prev is NowPlayingState &&
                cur is NowPlayingState &&
                prev.songInfo.coverArt != cur.songInfo.coverArt) ||
            (!(prev is NowPlayingState && cur is NowPlayingState)),
        builder: (BuildContext ctx, PlayerState state) {
          if (state is NowPlayingState) {
            return Center(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Column(children: [
                    Transform(
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.005)
                        ..rotateY(-0.3),
                      alignment: FractionalOffset.center,
                        child: Expanded(
                        flex: 2,
                        child: Container(
                          width: mediaQuery.size.width / 3,
                          height: mediaQuery.size.width / 3,
                          child: state.songInfo.coverArt ?? FittedBox(),
            
                        ),
                      ),
                    ),
                    // reflect the album art accross the x axis
                    Opacity(
                      opacity: 0.1,
                      child: Transform(
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.005)
                          ..rotateY(-0.3)
                          ..rotateX(pi),
                        alignment: FractionalOffset.center,
                          child: Container(
                            
                            width: mediaQuery.size.width / 3,
                            height: mediaQuery.size.width / 3,
                            child: state.songInfo.coverArt ?? FittedBox(),
              
                      
                        ),
                      ),
                    )
                   
                  ],),
                  
                  Expanded(
                    flex: 3,
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Align(
                              alignment: Alignment.centerLeft,
                              child: MarqueeWidget(
                                  direction: Axis.horizontal,
                                  child: Text(
                                    state.songInfo.title, 
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Calibre-Semibold",
                    
                                    )
                                  )
                                ),
                            ),
                            SizedBox(height: 5.0),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                state.songInfo.artistName,
                                style: TextStyle(
                                  color: Color.fromARGB(255, 106, 106, 106),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15
                                ),
                              ),
                            ),
                            SizedBox(height: 5.0),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: MarqueeWidget(
                                  direction: Axis.horizontal,
                                  child: Text(
                                    state.songInfo.albumTitle,
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 106, 106, 106),
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Calibre-Semibold",
                    
                                    )
                                  )
                                ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return Container(
            child: Center(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Container(
                      width: mediaQuery.size.width / 2.5,
                      height: mediaQuery.size.height / 4.9,
                      //child: state.songInfo.album.coverArt,
                      decoration: BoxDecoration(
                        color: Colors.grey[350],
                        shape: BoxShape.rectangle,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Loading Song...",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontFamily: "Calibre-Semibold",
                                fontSize: 20.0,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 4.0),
                            Text(
                              "",
                              style: TextStyle(
                                fontFamily: "Calibre-Semibold",
                                color: Color(0xFF7D9AFF),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
