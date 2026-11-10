import 'package:flutter/material.dart';

import '../models/gate_kind.dart';

// The connection points of a drawn gate.
// Wires are attached to these points.
class GatePins {
  // Where the first input (A) touches the gate.
  final Offset inputTop;

  // Where the second input (B) touches the gate.
  // A NOT gate has only one input, so this is the same point as inputTop.
  final Offset inputBottom;

  // Where the output leaves the gate.
  final Offset output;

  const GatePins({
    required this.inputTop,
    required this.inputBottom,
    required this.output,
  });
}

// Draws gate symbols on a canvas.
// This one class is used by the single gate pictures, by the circuit
// diagrams and by the app logo, so every gate looks the same.
class GateShapes {
  // The gate body does not fill the whole box.
  // The left and right parts of the box are the input and output wires.
  static const double _leadFraction = 0.18;

  // Size of the small circle on NAND, NOR and NOT, relative to the height.
  static const double _bubbleFraction = 0.09;

  // The two inputs sit at 30% and 70% of the gate height.
  static const double _upperInputFraction = 0.3;
  static const double _lowerInputFraction = 0.7;

  // Draws a gate inside [box] and returns where its wires connect.
  static GatePins draw(Canvas canvas, GateKind kind, Rect box, Paint paint) {
    switch (kind) {
      case GateKind.and:
        return _drawAnd(canvas, box, paint, hasBubble: false);
      case GateKind.nand:
        return _drawAnd(canvas, box, paint, hasBubble: true);
      case GateKind.or:
        return _drawOr(canvas, box, paint, hasBubble: false, isXor: false);
      case GateKind.nor:
        return _drawOr(canvas, box, paint, hasBubble: true, isXor: false);
      case GateKind.xor:
        return _drawOr(canvas, box, paint, hasBubble: false, isXor: true);
      case GateKind.xnor:
        return _drawOr(canvas, box, paint, hasBubble: true, isXor: true);
      case GateKind.not:
        return _drawNot(canvas, box, paint);
    }
  }

  // AND and NAND: flat back, round front.
  static GatePins _drawAnd(
    Canvas canvas,
    Rect box,
    Paint paint, {
    required bool hasBubble,
  }) {
    final double leadLength = box.width * _leadFraction;
    final double bubbleRadius = hasBubble ? box.height * _bubbleFraction : 0.0;
    final double bodyLeft = box.left + leadLength;
    final double bodyRight = box.right - leadLength - 2 * bubbleRadius;
    final double top = box.top;
    final double bottom = box.bottom;
    final double centerY = box.center.dy;
    final double upperInputY = top + box.height * _upperInputFraction;
    final double lowerInputY = top + box.height * _lowerInputFraction;

    // The front is a half circle. flatEnd is where the half circle starts.
    final double radius = box.height / 2;
    final double flatEnd = bodyRight - radius;

    final Path body = Path()
      ..moveTo(bodyLeft, top)
      ..lineTo(flatEnd, top)
      ..arcToPoint(
        Offset(flatEnd, bottom),
        radius: Radius.circular(radius),
        clockwise: true,
      )
      ..lineTo(bodyLeft, bottom)
      ..close();
    canvas.drawPath(body, paint);

    // Input wires.
    canvas.drawLine(
        Offset(box.left, upperInputY), Offset(bodyLeft, upperInputY), paint);
    canvas.drawLine(
        Offset(box.left, lowerInputY), Offset(bodyLeft, lowerInputY), paint);

    // Output wire, and the small circle for NAND.
    if (hasBubble) {
      canvas.drawCircle(
          Offset(bodyRight + bubbleRadius, centerY), bubbleRadius, paint);
    }
    canvas.drawLine(Offset(bodyRight + 2 * bubbleRadius, centerY),
        Offset(box.right, centerY), paint);

    return GatePins(
      inputTop: Offset(box.left, upperInputY),
      inputBottom: Offset(box.left, lowerInputY),
      output: Offset(box.right, centerY),
    );
  }

  // OR, NOR and XOR: curved back, pointed front.
  // XOR has one extra curve behind the body.
  static GatePins _drawOr(
    Canvas canvas,
    Rect box,
    Paint paint, {
    required bool hasBubble,
    required bool isXor,
  }) {
    final double leadLength = box.width * _leadFraction;
    final double bubbleRadius = hasBubble ? box.height * _bubbleFraction : 0.0;
    final double xorGap = isXor ? box.width * 0.07 : 0.0;

    // outerLeft is the back curve. For XOR the body starts a little
    // further right, at mainLeft.
    final double outerLeft = box.left + leadLength;
    final double mainLeft = outerLeft + xorGap;
    final double tipX = box.right - leadLength - 2 * bubbleRadius;
    final double bodyWidth = tipX - mainLeft;

    final double backCurveOffset = bodyWidth * 0.4;
    final double frontControlX = mainLeft + bodyWidth * 0.6;

    final double top = box.top;
    final double bottom = box.bottom;
    final double centerY = box.center.dy;
    final double upperInputY = top + box.height * _upperInputFraction;
    final double lowerInputY = top + box.height * _lowerInputFraction;

    final Path body = Path()
      ..moveTo(mainLeft, top)
      ..quadraticBezierTo(frontControlX, top, tipX, centerY)
      ..quadraticBezierTo(frontControlX, bottom, mainLeft, bottom)
      ..quadraticBezierTo(mainLeft + backCurveOffset, centerY, mainLeft, top)
      ..close();
    canvas.drawPath(body, paint);

    // The extra curve of the XOR gate.
    if (isXor) {
      final Path extraCurve = Path()
        ..moveTo(outerLeft, bottom)
        ..quadraticBezierTo(outerLeft + backCurveOffset, centerY, outerLeft, top);
      canvas.drawPath(extraCurve, paint);
    }

    // The back of the gate is curved, so the input wires must reach
    // a little into the box to touch the curve. 0.42 comes from the
    // curve equation at 30% and 70% of the height.
    final double wireEndX = outerLeft + 0.42 * backCurveOffset;
    canvas.drawLine(
        Offset(box.left, upperInputY), Offset(wireEndX, upperInputY), paint);
    canvas.drawLine(
        Offset(box.left, lowerInputY), Offset(wireEndX, lowerInputY), paint);

    // Output wire, and the small circle for NOR.
    if (hasBubble) {
      canvas.drawCircle(Offset(tipX + bubbleRadius, centerY), bubbleRadius, paint);
    }
    canvas.drawLine(Offset(tipX + 2 * bubbleRadius, centerY),
        Offset(box.right, centerY), paint);

    return GatePins(
      inputTop: Offset(box.left, upperInputY),
      inputBottom: Offset(box.left, lowerInputY),
      output: Offset(box.right, centerY),
    );
  }

  // NOT: a triangle with a small circle at the tip.
  static GatePins _drawNot(Canvas canvas, Rect box, Paint paint) {
    final double leadLength = box.width * _leadFraction;
    final double bubbleRadius = box.height * 0.11;
    final double bodyLeft = box.left + leadLength;
    final double tipX = box.right - leadLength - 2 * bubbleRadius;
    final double top = box.top;
    final double bottom = box.bottom;
    final double centerY = box.center.dy;

    final Path triangle = Path()
      ..moveTo(bodyLeft, top)
      ..lineTo(bodyLeft, bottom)
      ..lineTo(tipX, centerY)
      ..close();
    canvas.drawPath(triangle, paint);

    canvas.drawCircle(Offset(tipX + bubbleRadius, centerY), bubbleRadius, paint);
    canvas.drawLine(
        Offset(box.left, centerY), Offset(bodyLeft, centerY), paint);
    canvas.drawLine(Offset(tipX + 2 * bubbleRadius, centerY),
        Offset(box.right, centerY), paint);

    // A NOT gate has a single input, so both input points are the same.
    return GatePins(
      inputTop: Offset(box.left, centerY),
      inputBottom: Offset(box.left, centerY),
      output: Offset(box.right, centerY),
    );
  }
}
