import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:retro/blocs/theme/theme_state.dart';
import 'package:retro/clickwheel/pan_handlers.dart';
import 'package:retro/clickwheel/wheel_content.dart';
import 'package:retro/games/breakout/breakout.dart';
import 'package:retro/main.dart';

Color wheelColor;
Color controlsColor;

Widget clickWheel(BuildContext context, ThemeState state) {
    wheelColor = state.wheelColor == WheelColor.black
        ? const Color(0xff151516)
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
              height: widgetSize,
              width: widgetSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: wheelColor,
              ),
              child: Stack(children: [
                menuButton(),
                fastForward(),
                fastRewind(),
                playButton()
              ]),
            ),
          ),
          GestureDetector(
            onTap: () {
              if(mainViewMode == MainViewMode.breakoutGame){
                if(breakoutGame.currentState?.isBreakoutGameOver == true && breakoutGame.currentState?.gameState == Game.fail){
                  breakoutGame.currentState?.restart();
                }
              }
              else {
                menuKey?.currentState?.select();
              }
              HapticFeedback.mediumImpact();
              SystemSound.play(SystemSoundType.click);
            },
            child: selectButton()
          ),
        ],
      ),
    );
  }