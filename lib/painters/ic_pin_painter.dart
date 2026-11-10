import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../app/app_theme.dart';
import '../models/ic_pin_info.dart';
import 'painter_text.dart';

// Draws a 14-pin IC chip seen from above, with every pin named.
//
// Pin numbering of a DIP-14 chip: the notch is at the top.
// Pins 1 to 7 run down the left side.
// Pins 8 to 14 run up the right side, so pin 14 is across from pin 1.
class IcPinPainter extends CustomPainter {
  final IcPinInfo pinInfo;

  // The colors of the current theme (light or dark).
  final AppPalette palette;

  const IcPinPainter({required this.pinInfo, required this.palette});

  // Size of the drawing. paint() scales it to fit the available space.
  static const Size designSize = Size(320, 256);

  static const double _bodyLeft = 110;
  static const double _bodyRight = 210;
  static const double _bodyTop = 14;
  static const double _bodyBottom = 242;
  static const double _firstPinY = 38;
  static const double _pinSpacing = 30;
  static const double _pinLength = 22;
  static const double _pinHalfWidth = 7;
  static const int _pinsPerSide = 7;

  @override
  void paint(Canvas canvas, Size size) {
    final double scale = size.width / designSize.width;
    canvas.save();
    canvas.scale(scale);

    _drawBody(canvas);
    for (int pinNumber = 1; pinNumber <= 2 * _pinsPerSide; pinNumber++) {
      _drawPin(canvas, pinNumber);
    }

    canvas.restore();
  }

  // The dark body, the notch at the top and the chip name.
  void _drawBody(Canvas canvas) {
    final Paint bodyPaint = Paint()..color = palette.chipBody;
    final Paint outlinePaint = Paint()
      ..color = palette.chipOutline
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    final RRect body = RRect.fromLTRBR(
      _bodyLeft,
      _bodyTop,
      _bodyRight,
      _bodyBottom,
      const Radius.circular(6),
    );
    canvas.drawRRect(body, bodyPaint);
    canvas.drawRRect(body, outlinePaint);

    // The notch is a half circle cut out of the top edge.
    final double centerX = (_bodyLeft + _bodyRight) / 2;
    final Paint notchPaint = Paint()..color = palette.card;
    canvas.drawArc(
      Rect.fromCircle(center: Offset(centerX, _bodyTop), radius: 11),
      0,
      math.pi,
      true,
      notchPaint,
    );

    // A small dot marks pin 1.
    final Paint dotPaint = Paint()..color = Colors.white;
    canvas.drawCircle(Offset(_bodyLeft + 12, _bodyTop + 14), 3, dotPaint);

    // The IC number, written sideways in the middle of the body.
    canvas.save();
    canvas.translate(centerX, (_bodyTop + _bodyBottom) / 2);
    canvas.rotate(-math.pi / 2);
    drawLabel(
      canvas,
      pinInfo.icNumber,
      Offset.zero,
      color: Colors.white,
      fontSize: 22,
      fontWeight: FontWeight.w700,
      anchor: LabelAnchor.center,
    );
    canvas.restore();
  }

  // Draws one pin: the metal leg, its number and its name.
  void _drawPin(Canvas canvas, int pinNumber) {
    final bool isLeftSide = pinNumber <= _pinsPerSide;

    // Row 0 is the top row. Left side: pins 1..7 go down.
    // Right side: pins 14..8 go down.
    final int row = isLeftSide ? pinNumber - 1 : 2 * _pinsPerSide - pinNumber;
    final double centerY = _firstPinY + row * _pinSpacing;

    final String pinName = pinInfo.pinLabels[pinNumber - 1];

    // The metal leg.
    final double legLeft = isLeftSide ? _bodyLeft - _pinLength : _bodyRight;
    final Rect leg = Rect.fromLTWH(
      legLeft,
      centerY - _pinHalfWidth,
      _pinLength,
      2 * _pinHalfWidth,
    );
    final Paint legFill = Paint()..color = palette.chipLeg;
    final Paint legBorder = Paint()
      ..color = palette.chipOutline
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawRect(leg, legFill);
    canvas.drawRect(leg, legBorder);

    // The pin number, inside the body.
    final double numberX = isLeftSide ? _bodyLeft + 8 : _bodyRight - 8;
    drawLabel(
      canvas,
      '$pinNumber',
      Offset(numberX, centerY),
      color: Colors.white,
      fontSize: 13,
      anchor: isLeftSide ? LabelAnchor.left : LabelAnchor.right,
    );

    // The pin name, outside the chip. VCC and GND stand out.
    Color nameColor = palette.bodyText;
    FontWeight nameWeight = FontWeight.w600;
    if (pinName == 'VCC') {
      nameColor = palette.pinVcc;
      nameWeight = FontWeight.w800;
    } else if (pinName == 'GND') {
      nameColor = palette.pinGnd;
      nameWeight = FontWeight.w800;
    }
    final double nameX = isLeftSide ? legLeft - 8 : legLeft + _pinLength + 8;
    drawLabel(
      canvas,
      pinName,
      Offset(nameX, centerY),
      color: nameColor,
      fontSize: 16,
      fontWeight: nameWeight,
      anchor: isLeftSide ? LabelAnchor.right : LabelAnchor.left,
    );
  }

  @override
  bool shouldRepaint(IcPinPainter oldDelegate) {
    return oldDelegate.pinInfo != pinInfo || oldDelegate.palette != palette;
  }
}
