import 'package:flutter/material.dart';

import '../app/app_theme.dart';
import '../models/circuit_spec.dart';
import '../models/diagram_type.dart';
import '../models/gate_kind.dart';
import '../models/logic_block.dart';
import '../painters/circuit_painter.dart';
import '../painters/gate_symbol_painter.dart';
import '../painters/netlist_circuit_painter.dart';

// Shows the picture of a block:
//   - a single gate symbol for the seven gates,
//   - a hand-drawn circuit for the adders and subtractors,
//   - a circuit drawn from its CircuitSpec for the gates built from NAND
//     or NOR gates. Its wires change colour with the input values.
class DiagramView extends StatelessWidget {
  final LogicBlock block;

  // Current input values. Only the NAND and NOR circuits use them,
  // to colour their wires.
  final List<bool> inputValues;

  const DiagramView({
    super.key,
    required this.block,
    required this.inputValues,
  });

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = context.palette;

    final CircuitSpec? circuitSpec = block.circuitSpec;
    if (circuitSpec != null) {
      return _buildSpecCircuit(circuitSpec, palette);
    }

    final DiagramType diagramType = block.diagramType;
    final GateKind? gateKind = _gateKindFor(diagramType);

    // A single gate symbol.
    if (gateKind != null) {
      return SizedBox(
        height: 150,
        width: double.infinity,
        child: CustomPaint(
          painter: GateSymbolPainter(
            gateKind: gateKind,
            lineColor: palette.diagramLine,
            labelColor: palette.bodyText,
          ),
        ),
      );
    }

    // A hand-drawn circuit. The height follows the shape of the drawing.
    final Size designSize = CircuitPainter.designSizeFor(diagramType);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: AspectRatio(
        aspectRatio: designSize.width / designSize.height,
        child: CustomPaint(
          painter: CircuitPainter(
            diagramType: diagramType,
            lineColor: palette.diagramLine,
          ),
        ),
      ),
    );
  }

  // A circuit of NAND or NOR gates, with live wire colours.
  Widget _buildSpecCircuit(CircuitSpec circuitSpec, AppPalette palette) {
    final Size designSize = NetlistCircuitPainter.designSizeFor(circuitSpec);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          // The drawing is never enlarged by more than 25%, so a small
          // circuit does not become huge on a wide screen.
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: designSize.width * 1.25),
              child: AspectRatio(
                aspectRatio: designSize.width / designSize.height,
                child: CustomPaint(
                  painter: NetlistCircuitPainter(
                    circuit: circuitSpec,
                    inputLabels: block.inputLabels,
                    inputValues: inputValues,
                    lineColor: palette.diagramLine,
                  ),
                ),
              ),
            ),
          ),
        ),
        Text(
          'Green wire = 1, plain wire = 0. Tap the inputs below and watch '
          'the signal travel through the gates.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 13, color: palette.mutedText),
        ),
      ],
    );
  }

  // Returns the gate to draw, or null for a circuit.
  GateKind? _gateKindFor(DiagramType type) {
    switch (type) {
      case DiagramType.andGate:
        return GateKind.and;
      case DiagramType.orGate:
        return GateKind.or;
      case DiagramType.notGate:
        return GateKind.not;
      case DiagramType.nandGate:
        return GateKind.nand;
      case DiagramType.norGate:
        return GateKind.nor;
      case DiagramType.xorGate:
        return GateKind.xor;
      case DiagramType.xnorGate:
        return GateKind.xnor;
      default:
        return null;
    }
  }
}
