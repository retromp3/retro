import 'dart:math';

import 'package:flutter/material.dart';
import 'package:retro/main.dart';

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
    if (teta > 0) {
      menuKey?.currentState?.down();
    } else {
      menuKey?.currentState?.up();
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