import '../models/circuit_spec.dart';
import '../models/gate_kind.dart';

// NAND and NOR are called universal gates: every other gate can be built
// from NAND gates alone, or from NOR gates alone.
//
// The six circuit shapes below work for BOTH families. Each function takes
// the universal gate to use ([GateKind.nand] or [GateKind.nor]). For example
// the shape "two gates in a row" gives an AND gate when it is made of NAND
// gates, and an OR gate when it is made of NOR gates.
//
// Net names: 'A' and 'B' are the inputs. 'x1', 'x2' ... are the wires
// between gates. 'Y' is the final output.

// One gate with both inputs joined together. It works as a NOT gate:
//   Y = gate(A, A) = NOT A
CircuitSpec singleGateAsNotCircuit(GateKind universalGate) {
  return CircuitSpec(
    finalOutputNet: 'Y',
    gates: [
      CircuitGateSpec(
        kind: universalGate,
        firstInputNet: 'A',
        secondInputNet: 'A',
        outputNet: 'Y',
        column: 0,
        row: 0,
      ),
    ],
  );
}

// Two gates in a row. The second gate has both inputs joined, so it is a
// NOT gate that inverts the result of the first gate.
//   Y = NOT(gate(A, B))
//   NAND gates give AND.   NOR gates give OR.
CircuitSpec twoGatesInRowCircuit(GateKind universalGate) {
  return CircuitSpec(
    finalOutputNet: 'Y',
    gates: [
      CircuitGateSpec(
        kind: universalGate,
        firstInputNet: 'A',
        secondInputNet: 'B',
        outputNet: 'x1',
        column: 0,
        row: 0,
      ),
      CircuitGateSpec(
        kind: universalGate,
        firstInputNet: 'x1',
        secondInputNet: 'x1',
        outputNet: 'Y',
        column: 1,
        row: 0,
      ),
    ],
  );
}

// Three gates: two NOT gates invert A and B, and a third gate combines
// the inverted inputs.
//   Y = gate(NOT A, NOT B)
//   NAND gates give OR.   NOR gates give AND.   (De Morgan's law)
CircuitSpec invertedInputsCircuit(GateKind universalGate) {
  return CircuitSpec(
    finalOutputNet: 'Y',
    gates: [
      CircuitGateSpec(
        kind: universalGate,
        firstInputNet: 'A',
        secondInputNet: 'A',
        outputNet: 'x1',
        column: 0,
        row: 0,
      ),
      CircuitGateSpec(
        kind: universalGate,
        firstInputNet: 'B',
        secondInputNet: 'B',
        outputNet: 'x2',
        column: 0,
        row: 1,
      ),
      CircuitGateSpec(
        kind: universalGate,
        firstInputNet: 'x1',
        secondInputNet: 'x2',
        outputNet: 'Y',
        column: 1,
        row: 0.5,
      ),
    ],
  );
}

// The three-gate circuit above followed by a fourth gate used as a NOT gate.
//   NAND gates give NOR.   NOR gates give NAND.
CircuitSpec invertedInputsThenNotCircuit(GateKind universalGate) {
  return CircuitSpec(
    finalOutputNet: 'Y',
    gates: [
      ...invertedInputsCircuit(universalGate).gates.map(
        (CircuitGateSpec gate) => gate.outputNet == 'Y'
            ? CircuitGateSpec(
                kind: gate.kind,
                firstInputNet: gate.firstInputNet,
                secondInputNet: gate.secondInputNet,
                outputNet: 'x3',
                column: gate.column,
                row: gate.row,
              )
            : gate,
      ),
      CircuitGateSpec(
        kind: universalGate,
        firstInputNet: 'x3',
        secondInputNet: 'x3',
        outputNet: 'Y',
        column: 2,
        row: 0.5,
      ),
    ],
  );
}

// The classic four-gate circuit:
//   x1 = gate(A, B)
//   x2 = gate(A, x1)
//   x3 = gate(B, x1)
//   Y  = gate(x2, x3)
//   NAND gates give XOR.   NOR gates give XNOR.
CircuitSpec fourGateCircuit(GateKind universalGate) {
  return CircuitSpec(
    finalOutputNet: 'Y',
    gates: _fourGateGates(universalGate, finalOutputName: 'Y'),
  );
}

// The four-gate circuit followed by a fifth gate used as a NOT gate.
//   NAND gates give XNOR.   NOR gates give XOR.
CircuitSpec fourGateThenNotCircuit(GateKind universalGate) {
  return CircuitSpec(
    finalOutputNet: 'Y',
    gates: [
      ..._fourGateGates(universalGate, finalOutputName: 'x4'),
      CircuitGateSpec(
        kind: universalGate,
        firstInputNet: 'x4',
        secondInputNet: 'x4',
        outputNet: 'Y',
        column: 3,
        row: 1,
      ),
    ],
  );
}

// The four gates shared by the two circuits above.
List<CircuitGateSpec> _fourGateGates(
  GateKind universalGate, {
  required String finalOutputName,
}) {
  return [
    CircuitGateSpec(
      kind: universalGate,
      firstInputNet: 'A',
      secondInputNet: 'B',
      outputNet: 'x1',
      column: 0,
      row: 1,
    ),
    CircuitGateSpec(
      kind: universalGate,
      firstInputNet: 'A',
      secondInputNet: 'x1',
      outputNet: 'x2',
      column: 1,
      row: 0,
    ),
    CircuitGateSpec(
      kind: universalGate,
      firstInputNet: 'x1',
      secondInputNet: 'B',
      outputNet: 'x3',
      column: 1,
      row: 2,
    ),
    CircuitGateSpec(
      kind: universalGate,
      firstInputNet: 'x2',
      secondInputNet: 'x3',
      outputNet: finalOutputName,
      column: 2,
      row: 1,
    ),
  ];
}
