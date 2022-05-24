import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:retro/blocs/theme/theme_state.dart';
import 'package:retro/clickwheel/pan_handlers.dart';
import 'package:retro/clickwheel/wheel_content.dart';
import 'package:retro/main.dart';

Color wheelColor;
Color controlsColor;

Widget clickWheel(BuildContext context, ThemeState state) {
    wheelColor = state.wheelColor == WheelColor.black
        ? const Color(0xff151516)
        : Colors.white;
        
 
    controlsColor = state.wheelColor == WheelColor.white
        ? Color.fromARGB(255, 185, 185, 190)
        : Colors.white;
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
              HapticFeedback.mediumImpact();
              SystemSound.play(SystemSoundType.click);
              menuKey.currentState?.select();
            },
            child: selectButton()
          ),
        ],
      ),
    );
  }