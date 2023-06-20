import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kenburns_nullsafety/kenburns_nullsafety.dart';
import 'package:retro/blocs/songs/song_list_state.dart';

import '../blocs/songs/song_list_bloc.dart';

class CoverCycle extends StatefulWidget {
  final bool autoScroll;

  const CoverCycle({Key key, bool autoScroll})
      : this.autoScroll = autoScroll ?? false,
        super(key: key);

  @override
  CoverCycleState createState() => CoverCycleState();
}

class CoverCycleState extends State<CoverCycle> {
  final GlobalKey<_CoverCycleInternalState> _globalKey = GlobalKey();


  @override
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SongListBloc, SongListState>(
      builder: (BuildContext context, SongListState state) {
        if (state is SongListNotConnected) {
          return Container(
              decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomRight,
                end: Alignment.topLeft,
                stops: [0.1, 1.0],
                colors: [Color.fromARGB(255, 70, 74, 94), Color.fromARGB(255, 185, 192, 212)],
              ),
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(255, 36, 36, 36).withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: Offset(0, -2), // changes position of shadow
                ),
              ],
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/onboarding/beam.png',
                    width: 80,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'No Music',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
        );
        } else if (state is SongListConnectionError) {
          return Center(
              child: Padding(padding: EdgeInsets.all(10), child: Text(
            'Connection error occurred.',
            textAlign: TextAlign.center,
          )));
        } else if (state is SongListInProgress) {
          return Container(
              decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomRight,
                end: Alignment.topLeft,
                stops: [0.1, 1.0],
                colors: [Color.fromARGB(255, 70, 74, 94), Color.fromARGB(255, 185, 192, 212)],
              ),
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(255, 36, 36, 36).withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: Offset(0, -2), // changes position of shadow
                ),
              ],
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/onboarding/beam.png',
                    width: 80,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Loading...',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
        );
        } else if (state is SongListFetchError) {
          return Container(
              decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomRight,
                end: Alignment.topLeft,
                stops: [0.1, 1.0],
                colors: [Color.fromARGB(255, 70, 74, 94), Color.fromARGB(255, 185, 192, 212)],
              ),
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(255, 36, 36, 36).withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: Offset(0, -2), // changes position of shadow
                ),
              ],
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/onboarding/error.png',
                    width: 80,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Error',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
        );
        } else if (state is SongListFetchSuccess) {
          return _CoverCycleInternal(
            autoScroll: widget.autoScroll,
            songState: state,
            key: _globalKey,
          );
        }
        return FittedBox();
      },
    );
  }
}

class _CoverCycleInternal extends StatefulWidget {
  final SongListFetchSuccess songState;
  final bool autoScroll;

  const _CoverCycleInternal({
    Key key,
    this.songState,
    bool autoScroll,
  })  : assert(songState != null),
        this.autoScroll = autoScroll ?? false,
        super(key: key);

  @override
  _CoverCycleInternalState createState() =>
      _CoverCycleInternalState();
}

class _CoverCycleInternalState
    extends State<_CoverCycleInternal> {
  final PageController _pageCtrl = PageController(viewportFraction: 0.6);
  Timer _timer;
  double _currentPage = 0.0;
  bool _animationInProgress;
  int randIndex;

  @override
  void initState() {
    _animationInProgress = false;
    _pageCtrl.addListener(() {
      setState(() {
        _currentPage = _pageCtrl.page;
      });
    });
    _startPageTimer();
    randIndexFunc();
    super.initState();
  }

  void randIndexFunc() {
    int max = widget.songState.albumList.length;
    randIndex = Random().nextInt(max) + 1;
  }

  void next() {
    if (!_animationInProgress &&
        _currentPage < widget.songState.albumList.length - 1) {
      _animationInProgress = true;
      _currentPage++;
      _animateToPage().then((_) => _animationInProgress = false);
    }
  }

  void prev() {
    if (!_animationInProgress && _currentPage > 0) {
      _animationInProgress = true;
      _currentPage--;
      _animateToPage().then((_) => _animationInProgress = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    int numSongs = widget.songState.albumList.length;

    return PageView.builder(
      physics: NeverScrollableScrollPhysics(),
      //itemCount: widget.songState.albumList.length,
      //Colors.accents.length,
      itemBuilder: (context, __) {
        return (numSongs > 0) 
        ? Container(
          child: KenBurns.multiple(
            minAnimationDuration : Duration(milliseconds: 3000),
            maxAnimationDuration : Duration(milliseconds: 8000),
            maxScale : 2,
            //child:  FittedBox(fit: BoxFit.cover, child: widget.songState.albumList[0].coverArt,),
            //childLoop: (widget.songState.albumList.length),
            children: [

              for(int i = 0; i < widget.songState.albumList.length; i++) 
                FittedBox(fit: BoxFit.cover, child: widget.songState.albumList[i].coverArt,),
            ],
            
          ),
        )
        : Container(
              decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomRight,
                end: Alignment.topLeft,
                stops: [0.1, 1.0],
                colors: [Color.fromARGB(255, 70, 74, 94), Color.fromARGB(255, 185, 192, 212)],
              ),
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(255, 36, 36, 36).withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: Offset(0, -2), // changes position of shadow
                ),
              ],
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/onboarding/beam.png',
                    width: 80,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'No Music',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
        );

      },
    );
  }

  void _startPageTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 5), (Timer timer) {
      //currentIdx = currentIdx + 1;

      //_animateToPage();
    });
  }

  Future<void> _animateToPage() {
    return _pageCtrl?.animateToPage(
      _currentPage.toInt(),
      duration: Duration(milliseconds: 550),
      curve: Curves.easeIn,
    );
  }

  @override
  void dispose() {
    print('dispose');
    _timer?.cancel();
    _pageCtrl?.dispose();
    super.dispose();
  }
}
