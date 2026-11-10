import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../app/app_theme.dart';
import '../logic/circuit_evaluator.dart';
import '../models/circuit_spec.dart';
import 'gate_shapes.dart';
import 'painter_text.dart';

// Draws a circuit that is described by a CircuitSpec (the gates built from
// NAND or NOR gates), and colours every wire by its live value:
// green = 1, dark = 0. When the user taps an input, the painter is given
// the new input values and the colours change.
//
// How the wires are routed:
//   - Every wire (net) has one source: a gate output or a circuit input.
//   - Next to the source the wire runs along one vertical "bus" line.
//   - From the bus, a short horizontal branch goes into every gate input
//     that uses the wire.
//   - A filled dot marks a place where three or more wire pieces meet.
//     Two wires that cross without a dot are NOT connected.
//
// All coordinates are in a fixed "design size" (see designSizeFor).
// paint() scales the drawing to the space it is given.
class NetlistCircuitPainter extends CustomPainter {
  final CircuitSpec circuit;
  final List<String> inputLabels;
  final List<bool> inputValues;
  final Color lineColor;

  const NetlistCircuitPainter({
    required this.circuit,
    required this.inputLabels,
    required this.inputValues,
    required this.lineColor,
  });

  // Size of one gate.
  static const double _gateWidth = 76;
  static const double _gateHeight = 52;

  // Distance between the left edges of two neighbouring columns / rows.
  static const double _columnStep = 122;
  static const double _rowStep = 84;

  // Space around the drawing.
  static const double _topMargin = 12;
  static const double _bottomMargin = 12;

  // Where the first column of gates starts.
  static const double _firstGateX = 84;

  // The input names (A, B) are written at _labelX. The input wires start
  // at _wireStartX. The vertical bus of the first input is at
  // _firstInputBusX, and the next input's bus is _busSpacing further right.
  static const double _labelX = 6;
  static const double _wireStartX = 32;
  static const double _firstInputBusX = 44;
  static const double _busSpacing = 12;

  // A gate output runs this far right before its bus line.
  static const double _outputToBusDistance = 10;

  // The final output wire and its label.
  static const double _outputWireLength = 34;
  static const double _outputLabelGap = 8;
  static const double _outputLabelRoom = 22;

  static const double _labelFontSize = 17;
  static const double _dotRadius = 4.5;
  static const double _lineWidth = 3;

  // Size of the drawing for a circuit.
  static Size designSizeFor(CircuitSpec circuit) {
    final double width = _firstGateX +
        (circuit.columnCount - 1) * _columnStep +
        _gateWidth +
        _outputWireLength +
        _outputLabelGap +
        _outputLabelRoom;
    final double height =
        _topMargin + circuit.lastRow * _rowStep + _gateHeight + _bottomMargin;
    return Size(width, height);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final Size designSize = designSizeFor(circuit);
    canvas.save();
    canvas.scale(size.width / designSize.width);

    final Map<String, bool> netValues =
        evaluateCircuitNets(circuit, inputLabels, inputValues);

    // 1. Draw the gates and remember where their pins are.
    final Paint gatePaint = _linePaint(lineColor);
    final List<GatePins> gatePins = [];
    for (final CircuitGateSpec gate in circuit.gates) {
      final Rect box = Rect.fromLTWH(
        _firstGateX + gate.column * _columnStep,
        _topMargin + gate.row * _rowStep,
        _gateWidth,
        _gateHeight,
      );
      gatePins.add(GateShapes.draw(canvas, gate.kind, box, gatePaint));
    }

    // 2. Find every point that each wire must reach.
    final Map<String, List<Offset>> sinksByNet = {};
    for (int i = 0; i < circuit.gates.length; i++) {
      final CircuitGateSpec gate = circuit.gates[i];
      sinksByNet
          .putIfAbsent(gate.firstInputNet, () => [])
          .add(gatePins[i].inputTop);
      sinksByNet
          .putIfAbsent(gate.secondInputNet, () => [])
          .add(gatePins[i].inputBottom);
    }

    // 3. Draw the wires of the circuit inputs.
    for (int i = 0; i < inputLabels.length; i++) {
      final String netName = inputLabels[i];
      final List<Offset> sinks = sinksByNet[netName] ?? [];
      if (sinks.isEmpty) {
        continue;
      }

      // The input wire enters at the height of the first gate input
      // that uses it, with the name of the input written next to it.
      final Offset source = Offset(_wireStartX, sinks.first.dy);
      final double busX = _firstInputBusX + i * _busSpacing;
      _drawNet(
        canvas,
        source: source,
        busX: busX,
        sinks: sinks,
        color: _colorOf(netValues[netName]!),
      );
      drawLabel(
        canvas,
        netName,
        Offset(_labelX, source.dy),
        color: lineColor,
        fontSize: _labelFontSize,
        anchor: LabelAnchor.left,
      );
    }

    // 4. Draw the wires that leave the gates.
    // Wires that start in the same column get different bus positions,
    // so that their vertical lines do not lie on top of each other.
    final Map<int, int> busCountPerColumn = {};
    for (int i = 0; i < circuit.gates.length; i++) {
      final CircuitGateSpec gate = circuit.gates[i];
      final Offset source = gatePins[i].output;
      final Color color = _colorOf(netValues[gate.outputNet]!);

      if (gate.outputNet == circuit.finalOutputNet) {
        // The final result: a wire to the right edge, labelled Y.
        final Offset end = Offset(source.dx + _outputWireLength, source.dy);
        _drawNet(canvas, source: source, busX: end.dx, sinks: [end], color: color);
        drawLabel(
          canvas,
          'Y',
          end + const Offset(_outputLabelGap, 0),
          color: lineColor,
          fontSize: _labelFontSize,
          anchor: LabelAnchor.left,
        );
        continue;
      }

      final int busNumber = busCountPerColumn[gate.column] ?? 0;
      busCountPerColumn[gate.column] = busNumber + 1;
      final double busX =
          source.dx + _outputToBusDistance + busNumber * _busSpacing;
      _drawNet(
        canvas,
        source: source,
        busX: busX,
        sinks: sinksByNet[gate.outputNet] ?? [],
        color: color,
      );
    }

    canvas.restore();
  }

  // Draws one wire: from the source along the bus line to every sink.
  void _drawNet(
    Canvas canvas, {
    required Offset source,
    required double busX,
    required List<Offset> sinks,
    required Color color,
  }) {
    final Paint paint = _linePaint(color);

    // The bus line spans from the highest to the lowest connection point.
    double busTop = source.dy;
    double busBottom = source.dy;
    for (final Offset sink in sinks) {
      busTop = sink.dy < busTop ? sink.dy : busTop;
      busBottom = sink.dy > busBottom ? sink.dy : busBottom;
    }

    final Path path = Path()
      ..moveTo(source.dx, source.dy)
      ..lineTo(busX, source.dy)
      ..moveTo(busX, busTop)
      ..lineTo(busX, busBottom);
    for (final Offset sink in sinks) {
      path
        ..moveTo(busX, sink.dy)
        ..lineTo(sink.dx, sink.dy);
    }
    canvas.drawPath(path, paint);

    // A dot wherever three or more pieces of wire meet on the bus.
    final Paint dotPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final List<double> connectionHeights = [source.dy];
    for (final Offset sink in sinks) {
      connectionHeights.add(sink.dy);
    }
    final List<double> dotHeights = [];
    for (final double y in connectionHeights) {
      if (dotHeights.any((double done) => (done - y).abs() < 0.01)) {
        continue;
      }
      int pieces = 0;
      if (y > busTop + 0.01) pieces++; // bus continues upwards
      if (y < busBottom - 0.01) pieces++; // bus continues downwards
      if ((y - source.dy).abs() < 0.01) pieces++; // the source wire arrives
      for (final Offset sink in sinks) {
        if ((y - sink.dy).abs() < 0.01) {
          pieces++; // a branch leaves towards a gate input
          break;
        }
      }
      if (pieces >= 3) {
        canvas.drawCircle(Offset(busX, y), _dotRadius, dotPaint);
        dotHeights.add(y);
      }
    }
  }

  Paint _linePaint(Color color) {
    return Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = _lineWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
  }

  // Green for 1, the normal line colour for 0.
  Color _colorOf(bool value) {
    return value ? AppColors.ledOn : lineColor;
  }

  @override
  bool shouldRepaint(NetlistCircuitPainter oldDelegate) {
    return oldDelegate.circuit != circuit ||
        oldDelegate.lineColor != lineColor ||
        !listEquals(oldDelegate.inputValues, inputValues);
  }
}
