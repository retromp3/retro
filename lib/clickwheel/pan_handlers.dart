import 'dart:math';

import 'package:flutter/material.dart';
import 'package:retro/main.dart';

final stopwatch = Stopwatch(); //On iPod, fast scrolling begins about 1-2 seconds after the start of scrolling
int oldTime = 0;
bool previousDirection;

void panUpdateHandler(DragUpdateDetails updateDetails) {
  final double cartesianCurX = halfSize - updateDetails.localPosition.dx;
  final double cartesianCurY = halfSize - updateDetails.localPosition.dy;

  final double radiusCur =
      sqrt(pow(cartesianCurX, 2) + pow(cartesianCurY, 2));

  if (testExtraRadius(radiusCur)) return;
  if (wasExtraRadius) {
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
    } else {
      scroll(true, stopwatch.elapsedMicroseconds);
      if (previousDirection == false) stopwatch.reset();
      previousDirection = true;
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

bool testExtraRadius(double radius) {
  if (radius > halfSize || radius < 0.1 * halfSize) {
    wasExtraRadius = true;
  } else {
    wasExtraRadius = false;
  }
  return wasExtraRadius;
}

void scroll (bool up, int micros) {
  int count = pow(2, (micros/1000000).floor()) - 1;
  if (up) menuKey?.currentState?.up(true); //play sound and haptics
  else menuKey?.currentState?.down(true);

  for (int i = 0; i < count; i++) {
    if (up) menuKey?.currentState?.up(false); //don't play them
    else menuKey?.currentState?.down(false);
  }
}
