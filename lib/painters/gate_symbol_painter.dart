import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/gate_kind.dart';
import 'gate_shapes.dart';
import 'painter_text.dart';

// Draws the picture of one single gate, with its input and output labels.
class GateSymbolPainter extends CustomPainter {
  final GateKind gateKind;
  final Color lineColor;

  // Color of the A, B and Y labels.
  final Color labelColor;

  const GateSymbolPainter({
    required this.gateKind,
    required this.lineColor,
    required this.labelColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint linePaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // The gate is drawn in the middle of the available space.
    final double boxHeight = size.height * 0.7;
    final double boxWidth = math.min(boxHeight * 1.6, size.width * 0.6);
    final Rect box = Rect.fromCenter(
      center: size.center(Offset.zero),
      width: boxWidth,
      height: boxHeight,
    );

    final GatePins pins = GateShapes.draw(canvas, gateKind, box, linePaint);

    // Labels for the inputs and the output.
    drawLabel(
      canvas,
      'A',
      pins.inputTop + const Offset(-8, 0),
      color: labelColor,
      anchor: LabelAnchor.right,
    );
    if (gateKind != GateKind.not) {
      drawLabel(
        canvas,
        'B',
        pins.inputBottom + const Offset(-8, 0),
        color: labelColor,
        anchor: LabelAnchor.right,
      );
    }
    drawLabel(
      canvas,
      'Y',
      pins.output + const Offset(8, 0),
      color: labelColor,
      anchor: LabelAnchor.left,
    );
  }

  @override
  bool shouldRepaint(GateSymbolPainter oldDelegate) {
    return oldDelegate.gateKind != gateKind ||
        oldDelegate.lineColor != lineColor ||
        oldDelegate.labelColor != labelColor;
  }
}
