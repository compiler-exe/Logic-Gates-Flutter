import '../models/circuit_spec.dart';
import '../models/gate_kind.dart';
import 'logic_functions.dart';

// Calculates the value of every wire (net) of a circuit that is built
// from NAND and NOR gates.
//
// [inputLabels] and [inputValues] describe the circuit inputs, for example
// ['A', 'B'] and [true, false]. The result maps every net name to its value,
// including the inputs, so the same result can drive both the output LEDs
// and the colours of the wires in the drawing.
Map<String, bool> evaluateCircuitNets(
  CircuitSpec circuit,
  List<String> inputLabels,
  List<bool> inputValues,
) {
  final Map<String, bool> netValues = {};
  for (int i = 0; i < inputLabels.length; i++) {
    netValues[inputLabels[i]] = inputValues[i];
  }

  for (final CircuitGateSpec gate in circuit.gates) {
    final bool first = netValues[gate.firstInputNet]!;
    final bool second = netValues[gate.secondInputNet]!;
    netValues[gate.outputNet] = _evaluateGate(gate.kind, first, second);
  }
  return netValues;
}

// Returns the final output of the circuit as a one-item list,
// which is the format the rest of the app expects from a logic function.
List<bool> computeCircuitOutputs(
  CircuitSpec circuit,
  List<String> inputLabels,
  List<bool> inputValues,
) {
  final Map<String, bool> netValues =
      evaluateCircuitNets(circuit, inputLabels, inputValues);
  return [netValues[circuit.finalOutputNet]!];
}

bool _evaluateGate(GateKind kind, bool first, bool second) {
  switch (kind) {
    case GateKind.nand:
      return nandOf(first, second);
    case GateKind.nor:
      return norOf(first, second);
    default:
      throw ArgumentError('Only NAND and NOR gates are used in these circuits.');
  }
}
