import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:retro/main.dart';
import 'package:perfect_volume_control/perfect_volume_control.dart';
import 'dart:async';

final stopwatch = Stopwatch(); //On iPod, fast scrolling begins about 1-2 seconds after the start of scrolling
int oldTime = 0;
bool? previousDirection;
double volume = 0.0;
bool isVolume = false;
Timer? volumeTimer;

void setVolume(double value) {
  isVolume = true; // Volume is being changed

  volume = min(1.0, max(0, value));

  // Only perform haptic feedback if volume is neither 0 nor 1
  if (volume != 0.0 && volume != 1.0) {
    HapticFeedback.lightImpact();
  }

  PerfectVolumeControl.setVolume(volume);

  // Cancel any existing timer
  volumeTimer?.cancel();

  // Start a new timer
  volumeTimer = Timer(Duration(seconds: 1), () {
    isVolume = false; // Volume is no longer being changed
  });
}




double getVolume() {
  return volume;
}

void panUpdateHandler(DragUpdateDetails updateDetails) {
  final double cartesianCurX = halfSize - updateDetails.localPosition.dx;
  final double cartesianCurY = halfSize - updateDetails.localPosition.dy;

  final double radiusCur =
      sqrt(pow(cartesianCurX, 2) + pow(cartesianCurY, 2));

  if (testExtraRadius(radiusCur)!) return;
  if (wasExtraRadius!) {
    setCartesianStart(
      updateDetails.localPosition.dx,
      updateDetails.localPosition.dy,
    );
    return;
  }

  final double cosTeta =
      (cartesianStartX * cartesianCurX + cartesianStartY * cartesianCurY) /
          (cartesianStartRadius * radiusCur);

  final double determinate =
      cartesianStartX * cartesianCurY - cartesianCurX * cartesianStartY;

  final double teta = acos(cosTeta) * (determinate > 0 ? 1.0 : -1.0);

  if (teta.abs() > tickAngel) {
    if (stopwatch.elapsedMilliseconds - 120 < oldTime) {
      if (!stopwatch.isRunning) stopwatch.start();
      oldTime = stopwatch.elapsedMilliseconds;
    } else {
      stopwatch.reset();
    }
    if (teta > 0) {
      scroll(false, stopwatch.elapsedMicroseconds);
      if (previousDirection == true) stopwatch.reset();
      previousDirection = false;

      if (mainViewMode == MainViewMode.player) {
        
        setVolume(getVolume() + (1.0 / 16.0));
      }

      if (mainViewMode == MainViewMode.breakoutGame) {
          breakoutGame.currentState?.moveRight();
          HapticFeedback.lightImpact();
      }
    } else if (teta < 0) {
      scroll(true, stopwatch.elapsedMicroseconds);
      if (previousDirection == false) stopwatch.reset();
      previousDirection = true;

      if (mainViewMode == MainViewMode.player) {
        
        setVolume(getVolume() - (1.0 / 16.0));
      }

      if (mainViewMode == MainViewMode.breakoutGame) {
          breakoutGame.currentState?.moveLeft();
          HapticFeedback.lightImpact();
      }
    }
    setCartesianStart(
      updateDetails.localPosition.dx,
      updateDetails.localPosition.dy,
    );
  }
}

void panStartHandler(DragStartDetails details) {
  setCartesianStart(details.localPosition.dx, details.localPosition.dy);
}

void setCartesianStart(double x, double y) {
  cartesianStartX = halfSize - x;
  cartesianStartY = halfSize - y;
  cartesianStartRadius =
      sqrt(pow(cartesianStartX, 2) + pow(cartesianStartY, 2));
  testExtraRadius(cartesianStartRadius);
}

bool? testExtraRadius(double radius) {
  if (radius > halfSize || radius < 0.1 * halfSize) {
    wasExtraRadius = true;
  } else {
    wasExtraRadius = false;
  }
  return wasExtraRadius;
}

void scroll (bool up, int micros) {
  int count = pow(2, (micros/1000000).floor()) - 1 as int;
  if(up) {
      popUp ? altMenuKey.currentState?.up(true) : menuKey.currentState?.up(true);
  }
  else {
      popUp ? altMenuKey.currentState?.down(true) : menuKey.currentState?.down(true);
  }

  for (int i = 0; i < count; i++) {
    if(up) {
      popUp ? altMenuKey.currentState?.up(false) : menuKey.currentState?.up(false);
    }
    else {
      popUp ? altMenuKey.currentState?.down(false) : menuKey.currentState?.down(false);
    }
  }
}
