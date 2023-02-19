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
  Widget build(BuildContext context) {
    return BlocBuilder<SongListBloc, SongListState>(
      builder: (BuildContext context, SongListState state) {
         if (state is SongListFetchSuccess) {
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
        : Container();
        
        
      /*  AlbumCover(
          idx: currentIdx,
          currentPage: _currentPage,
          coverArt: widget.songState.albumList[currentIdx + 1].coverArt,
        );*/
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

class AlbumCover extends StatelessWidget {
  final int idx;
  final double currentPage;
  final Image coverArt;

  AlbumCover({
    this.idx,
    this.currentPage,
    this.coverArt,
  });

  @override
  Widget build(BuildContext context) {
    double relativePosition = idx - currentPage;
    
  
    return Container(
      child: coverArt != null
        ?  FittedBox(
            fit: BoxFit.scaleDown,
            child: coverArt,
          )
        : Visibility(child: Container(), visible:false),
    );
  }
}
