import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:retro/blocs/theme/theme_state.dart';
import 'package:retro/clickwheel/pan_handlers.dart';
import 'package:retro/clickwheel/wheel_content.dart';
import 'package:retro/main.dart';

Color wheelColor;
Color controlsColor;
Color centreColor;

Widget clickWheel(BuildContext context, ThemeState state) {
    wheelColor = state.wheelColor == WheelColor.black
        ? const Color(0xff151516)
        : Colors.white;
        
 
    controlsColor = state.wheelColor == WheelColor.white
        ? const Color(0xff919194)
        : Colors.white;

    centreColor = state.wheelColor == WheelColor.white ? Colors.grey[300] : Color(0xFF1B1B1B);
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
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF5e5e5e),
                    centreColor,
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
                borderRadius: BorderRadius.circular(50),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    offset: Offset(5, 5),
                    blurRadius: 10,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }