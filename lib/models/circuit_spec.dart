import 'gate_kind.dart';

// One gate inside a circuit that is built from other gates.
//
// Every wire of the circuit has a name (a "net"). The inputs of the whole
// circuit are named after the input labels, for example 'A' and 'B'.
// Every gate creates one new net, named by [outputNet].
class CircuitGateSpec {
  // Which gate to draw and calculate. Only nand and nor are supported.
  final GateKind kind;

  // Names of the nets that go into the upper and the lower input pin.
  final String firstInputNet;
  final String secondInputNet;

  // Name of the net that leaves this gate.
  final String outputNet;

  // Where the gate is placed: column 0 is the left-most column.
  final int column;

  // Vertical position in rows. 0 is the top row. Half rows such as 0.5
  // are allowed, to put a gate between two others.
  final double row;

  const CircuitGateSpec({
    required this.kind,
    required this.firstInputNet,
    required this.secondInputNet,
    required this.outputNet,
    required this.column,
    required this.row,
  });
}

// A complete circuit made of NAND gates or NOR gates only.
class CircuitSpec {
  // The gates, in calculation order: a gate may only use the circuit
  // inputs and the outputs of gates that come before it in this list.
  final List<CircuitGateSpec> gates;

  // The net that is the final result of the circuit.
  final String finalOutputNet;

  const CircuitSpec({
    required this.gates,
    required this.finalOutputNet,
  });

  // The number of columns of gates.
  int get columnCount {
    int highestColumn = 0;
    for (final CircuitGateSpec gate in gates) {
      if (gate.column > highestColumn) {
        highestColumn = gate.column;
      }
    }
    return highestColumn + 1;
  }

  // The lowest row used by any gate.
  double get lastRow {
    double lowestRow = 0;
    for (final CircuitGateSpec gate in gates) {
      if (gate.row > lowestRow) {
        lowestRow = gate.row;
      }
    }
    return lowestRow;
  }
}
