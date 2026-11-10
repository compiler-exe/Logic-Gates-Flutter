import 'package:flutter/material.dart';

import '../models/diagram_type.dart';
import '../models/gate_kind.dart';
import 'gate_shapes.dart';
import 'painter_text.dart';

// Draws the circuit diagrams of the adders and subtractors.
// Each circuit is built from the same gate shapes used elsewhere in the app.
//
// All coordinates below are in a fixed "design size" (see designSizeFor).
// paint() scales the whole drawing to fit the space it is given,
// so the diagram looks the same on every screen.
//
// Drawing rules used in every circuit:
//   - A filled dot marks a place where a wire splits into two wires.
//   - Two wires that cross without a dot are NOT connected.
class CircuitPainter extends CustomPainter {
  final DiagramType diagramType;
  final Color lineColor;

  const CircuitPainter({
    required this.diagramType,
    required this.lineColor,
  });

  // Size of the gates used in the circuits.
  static const double _gateWidth = 84;
  static const double _gateHeight = 56;
  static const double _notWidth = 56;
  static const double _notHeight = 32;

  // Where the input wires start (the labels A, B, Cin are left of this).
  static const double _wireStartX = 46;
  static const double _labelX = 6;
  static const double _labelFontSize = 18;
  static const double _dotRadius = 4.5;

  // Size of the drawing for each circuit.
  static Size designSizeFor(DiagramType diagramType) {
    switch (diagramType) {
      case DiagramType.halfAdder:
        return const Size(440, 190);
      case DiagramType.fullAdder:
        return const Size(545, 285);
      case DiagramType.halfSubtractor:
        return const Size(440, 180);
      case DiagramType.fullSubtractor:
        return const Size(555, 300);
      default:
        return const Size(440, 190);
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final Size designSize = designSizeFor(diagramType);
    final double scale = size.width / designSize.width;

    final Paint linePaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final Paint dotPaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.fill;

    canvas.save();
    canvas.scale(scale);
    switch (diagramType) {
      case DiagramType.halfAdder:
        _drawHalfAdder(canvas, linePaint, dotPaint);
        break;
      case DiagramType.fullAdder:
        _drawFullAdder(canvas, linePaint, dotPaint);
        break;
      case DiagramType.halfSubtractor:
        _drawHalfSubtractor(canvas, linePaint, dotPaint);
        break;
      case DiagramType.fullSubtractor:
        _drawFullSubtractor(canvas, linePaint, dotPaint);
        break;
      default:
        break;
    }
    canvas.restore();
  }

  // ---------------------------------------------------------------
  // Small helpers
  // ---------------------------------------------------------------

  // The box of a two-input gate, from its top-left corner.
  Rect _gateBox(double left, double top) {
    return Rect.fromLTWH(left, top, _gateWidth, _gateHeight);
  }

  // The box of a NOT gate, placed so that its input is at centerY.
  Rect _notBox(double left, double centerY) {
    return Rect.fromLTWH(
        left, centerY - _notHeight / 2, _notWidth, _notHeight);
  }

  // Draws a wire through a list of points.
  void _wire(Canvas canvas, Paint paint, List<Offset> points) {
    final Path path = Path()..moveTo(points.first.dx, points.first.dy);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }
    canvas.drawPath(path, paint);
  }

  // Draws the dot where a wire splits.
  void _dot(Canvas canvas, Paint dotPaint, Offset position) {
    canvas.drawCircle(position, _dotRadius, dotPaint);
  }

  // Draws the name of an input, left of its wire.
  void _inputLabel(Canvas canvas, String text, double y) {
    drawLabel(
      canvas,
      text,
      Offset(_labelX, y),
      color: lineColor,
      fontSize: _labelFontSize,
      anchor: LabelAnchor.left,
    );
  }

  // Draws the name of an output, right of its wire.
  void _outputLabel(Canvas canvas, String text, Offset position) {
    drawLabel(
      canvas,
      text,
      position,
      color: lineColor,
      fontSize: _labelFontSize,
      anchor: LabelAnchor.left,
    );
  }

  // ---------------------------------------------------------------
  // Half adder: Sum = A XOR B, Carry = A AND B
  // ---------------------------------------------------------------
  void _drawHalfAdder(Canvas canvas, Paint line, Paint dot) {
    final GatePins xorPins =
        GateShapes.draw(canvas, GateKind.xor, _gateBox(120, 15), line);
    final GatePins andPins =
        GateShapes.draw(canvas, GateKind.and, _gateBox(120, 110), line);

    final double aY = xorPins.inputTop.dy;
    final double bY = xorPins.inputBottom.dy;

    // Inputs A and B go to the XOR gate.
    _inputLabel(canvas, 'A', aY);
    _inputLabel(canvas, 'B', bY);
    _wire(canvas, line, [Offset(_wireStartX, aY), xorPins.inputTop]);
    _wire(canvas, line, [Offset(_wireStartX, bY), xorPins.inputBottom]);

    // A splits and also goes to the lower input of the AND gate.
    _dot(canvas, dot, Offset(62, aY));
    _wire(canvas, line, [
      Offset(62, aY),
      Offset(62, andPins.inputBottom.dy),
      andPins.inputBottom,
    ]);

    // B splits and also goes to the upper input of the AND gate.
    _dot(canvas, dot, Offset(90, bY));
    _wire(canvas, line, [
      Offset(90, bY),
      Offset(90, andPins.inputTop.dy),
      andPins.inputTop,
    ]);

    // Outputs.
    _wire(canvas, line, [xorPins.output, Offset(330, xorPins.output.dy)]);
    _outputLabel(canvas, 'S', Offset(338, xorPins.output.dy));
    _wire(canvas, line, [andPins.output, Offset(330, andPins.output.dy)]);
    _outputLabel(canvas, 'C', Offset(338, andPins.output.dy));
  }

  // ---------------------------------------------------------------
  // Full adder: two half adders and an OR gate
  //   first XOR  : A XOR B
  //   second XOR : (A XOR B) XOR Cin      -> Sum
  //   first AND  : (A XOR B) AND Cin
  //   second AND : A AND B
  //   OR         : first AND OR second AND -> Cout
  // ---------------------------------------------------------------
  void _drawFullAdder(Canvas canvas, Paint line, Paint dot) {
    final GatePins firstXor =
        GateShapes.draw(canvas, GateKind.xor, _gateBox(100, 15), line);
    final GatePins secondXor =
        GateShapes.draw(canvas, GateKind.xor, _gateBox(220, 75), line);
    final GatePins firstAnd =
        GateShapes.draw(canvas, GateKind.and, _gateBox(220, 140), line);
    final GatePins secondAnd =
        GateShapes.draw(canvas, GateKind.and, _gateBox(220, 215), line);
    final GatePins orPins =
        GateShapes.draw(canvas, GateKind.or, _gateBox(370, 178), line);

    final double aY = firstXor.inputTop.dy;
    final double bY = firstXor.inputBottom.dy;
    final double cinY = secondXor.inputBottom.dy;

    _inputLabel(canvas, 'A', aY);
    _inputLabel(canvas, 'B', bY);
    _inputLabel(canvas, 'Cin', cinY);

    // Input A: to the first XOR, and down to the second AND.
    _wire(canvas, line, [Offset(_wireStartX, aY), firstXor.inputTop]);
    _dot(canvas, dot, Offset(62, aY));
    _wire(canvas, line, [
      Offset(62, aY),
      Offset(62, secondAnd.inputBottom.dy),
      secondAnd.inputBottom,
    ]);

    // Input B: to the first XOR, and down to the second AND.
    _wire(canvas, line, [Offset(_wireStartX, bY), firstXor.inputBottom]);
    _dot(canvas, dot, Offset(78, bY));
    _wire(canvas, line, [
      Offset(78, bY),
      Offset(78, secondAnd.inputTop.dy),
      secondAnd.inputTop,
    ]);

    // Input Cin: to the second XOR, and down to the first AND.
    _wire(canvas, line, [Offset(_wireStartX, cinY), secondXor.inputBottom]);
    _dot(canvas, dot, Offset(150, cinY));
    _wire(canvas, line, [
      Offset(150, cinY),
      Offset(150, firstAnd.inputBottom.dy),
      firstAnd.inputBottom,
    ]);

    // Output of the first XOR (A XOR B): to the second XOR and the first AND.
    _wire(canvas, line, [
      firstXor.output,
      Offset(200, firstXor.output.dy),
      Offset(200, secondXor.inputTop.dy),
      secondXor.inputTop,
    ]);
    _dot(canvas, dot, Offset(200, secondXor.inputTop.dy));
    _wire(canvas, line, [
      Offset(200, secondXor.inputTop.dy),
      Offset(200, firstAnd.inputTop.dy),
      firstAnd.inputTop,
    ]);

    // The two AND outputs go into the OR gate.
    _wire(canvas, line, [
      firstAnd.output,
      Offset(330, firstAnd.output.dy),
      Offset(330, orPins.inputTop.dy),
      orPins.inputTop,
    ]);
    _wire(canvas, line, [
      secondAnd.output,
      Offset(344, secondAnd.output.dy),
      Offset(344, orPins.inputBottom.dy),
      orPins.inputBottom,
    ]);

    // Outputs.
    _wire(canvas, line, [secondXor.output, Offset(490, secondXor.output.dy)]);
    _outputLabel(canvas, 'S', Offset(498, secondXor.output.dy));
    _wire(canvas, line, [orPins.output, Offset(490, orPins.output.dy)]);
    _outputLabel(canvas, 'Cout', Offset(498, orPins.output.dy));
  }

  // ---------------------------------------------------------------
  // Half subtractor: Difference = A XOR B, Borrow = (NOT A) AND B
  // ---------------------------------------------------------------
  void _drawHalfSubtractor(Canvas canvas, Paint line, Paint dot) {
    final GatePins xorPins =
        GateShapes.draw(canvas, GateKind.xor, _gateBox(110, 15), line);
    final GatePins andPins =
        GateShapes.draw(canvas, GateKind.and, _gateBox(200, 108), line);
    final GatePins notPins = GateShapes.draw(
        canvas, GateKind.not, _notBox(110, andPins.inputTop.dy), line);

    final double aY = xorPins.inputTop.dy;
    final double bY = xorPins.inputBottom.dy;

    _inputLabel(canvas, 'A', aY);
    _inputLabel(canvas, 'B', bY);

    // A goes to the XOR gate, and through the NOT gate to the AND gate.
    _wire(canvas, line, [Offset(_wireStartX, aY), xorPins.inputTop]);
    _dot(canvas, dot, Offset(62, aY));
    _wire(canvas, line, [
      Offset(62, aY),
      Offset(62, notPins.inputTop.dy),
      notPins.inputTop,
    ]);
    _wire(canvas, line, [notPins.output, andPins.inputTop]);

    // B goes to the XOR gate and to the AND gate.
    _wire(canvas, line, [Offset(_wireStartX, bY), xorPins.inputBottom]);
    _dot(canvas, dot, Offset(86, bY));
    _wire(canvas, line, [
      Offset(86, bY),
      Offset(86, andPins.inputBottom.dy),
      andPins.inputBottom,
    ]);

    // Outputs.
    _wire(canvas, line, [xorPins.output, Offset(330, xorPins.output.dy)]);
    _outputLabel(canvas, 'Difference', Offset(338, xorPins.output.dy));
    _wire(canvas, line, [andPins.output, Offset(330, andPins.output.dy)]);
    _outputLabel(canvas, 'Borrow', Offset(338, andPins.output.dy));
  }

  // ---------------------------------------------------------------
  // Full subtractor: two half subtractors and an OR gate
  //   first XOR   : A XOR B
  //   second XOR  : (A XOR B) XOR Bin               -> D
  //   first AND   : (NOT A) AND B
  //   second AND  : NOT(A XOR B) AND Bin
  //   OR          : first AND OR second AND          -> Bout
  // ---------------------------------------------------------------
  void _drawFullSubtractor(Canvas canvas, Paint line, Paint dot) {
    final GatePins firstXor =
        GateShapes.draw(canvas, GateKind.xor, _gateBox(100, 15), line);
    final GatePins secondXor =
        GateShapes.draw(canvas, GateKind.xor, _gateBox(220, 75), line);
    final GatePins borrowAndSecond =
        GateShapes.draw(canvas, GateKind.and, _gateBox(290, 140), line);
    final GatePins borrowAndFirst =
        GateShapes.draw(canvas, GateKind.and, _gateBox(290, 230), line);
    final GatePins orPins =
        GateShapes.draw(canvas, GateKind.or, _gateBox(400, 190), line);

    // NOT gate on (A XOR B), in front of the second AND.
    final GatePins notDifference = GateShapes.draw(
      canvas,
      GateKind.not,
      _notBox(210, borrowAndSecond.inputTop.dy),
      line,
    );
    // NOT gate on A, in front of the first AND.
    final GatePins notA = GateShapes.draw(
      canvas,
      GateKind.not,
      _notBox(210, borrowAndFirst.inputTop.dy),
      line,
    );

    final double aY = firstXor.inputTop.dy;
    final double bY = firstXor.inputBottom.dy;
    final double binY = secondXor.inputBottom.dy;

    _inputLabel(canvas, 'A', aY);
    _inputLabel(canvas, 'B', bY);
    _inputLabel(canvas, 'Bin', binY);

    // Input A: to the first XOR, and down through a NOT gate.
    _wire(canvas, line, [Offset(_wireStartX, aY), firstXor.inputTop]);
    _dot(canvas, dot, Offset(62, aY));
    _wire(canvas, line, [
      Offset(62, aY),
      Offset(62, notA.inputTop.dy),
      notA.inputTop,
    ]);
    _wire(canvas, line, [notA.output, borrowAndFirst.inputTop]);

    // Input B: to the first XOR, and down to the first AND.
    _wire(canvas, line, [Offset(_wireStartX, bY), firstXor.inputBottom]);
    _dot(canvas, dot, Offset(78, bY));
    _wire(canvas, line, [
      Offset(78, bY),
      Offset(78, borrowAndFirst.inputBottom.dy),
      borrowAndFirst.inputBottom,
    ]);

    // Input Bin: to the second XOR, and down to the second AND.
    _wire(canvas, line, [Offset(_wireStartX, binY), secondXor.inputBottom]);
    _dot(canvas, dot, Offset(150, binY));
    _wire(canvas, line, [
      Offset(150, binY),
      Offset(150, borrowAndSecond.inputBottom.dy),
      borrowAndSecond.inputBottom,
    ]);

    // Output of the first XOR (A XOR B): to the second XOR,
    // and down through a NOT gate to the second AND.
    _wire(canvas, line, [
      firstXor.output,
      Offset(196, firstXor.output.dy),
      Offset(196, secondXor.inputTop.dy),
      secondXor.inputTop,
    ]);
    _dot(canvas, dot, Offset(196, secondXor.inputTop.dy));
    _wire(canvas, line, [
      Offset(196, secondXor.inputTop.dy),
      Offset(196, notDifference.inputTop.dy),
      notDifference.inputTop,
    ]);
    _wire(canvas, line, [notDifference.output, borrowAndSecond.inputTop]);

    // The two AND outputs go into the OR gate.
    _wire(canvas, line, [
      borrowAndSecond.output,
      Offset(384, borrowAndSecond.output.dy),
      Offset(384, orPins.inputTop.dy),
      orPins.inputTop,
    ]);
    _wire(canvas, line, [
      borrowAndFirst.output,
      Offset(390, borrowAndFirst.output.dy),
      Offset(390, orPins.inputBottom.dy),
      orPins.inputBottom,
    ]);

    // Outputs.
    _wire(canvas, line, [secondXor.output, Offset(500, secondXor.output.dy)]);
    _outputLabel(canvas, 'D', Offset(508, secondXor.output.dy));
    _wire(canvas, line, [orPins.output, Offset(500, orPins.output.dy)]);
    _outputLabel(canvas, 'Bout', Offset(508, orPins.output.dy));
  }

  @override
  bool shouldRepaint(CircuitPainter oldDelegate) {
    return oldDelegate.diagramType != diagramType ||
        oldDelegate.lineColor != lineColor;
  }
}
