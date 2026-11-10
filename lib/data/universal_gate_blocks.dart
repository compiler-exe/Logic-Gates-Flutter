import '../logic/circuit_evaluator.dart';
import '../models/block_category.dart';
import '../models/circuit_spec.dart';
import '../models/diagram_type.dart';
import '../models/gate_kind.dart';
import '../models/logic_block.dart';
import 'universal_circuit_specs.dart';

// Gates built from NAND gates only, and gates built from NOR gates only.
// Every block here draws its circuit from a CircuitSpec, and its outputs
// are calculated by walking through the gates of that same CircuitSpec.
// So the picture, the LEDs and the truth table always agree.

// Makes one block from a circuit. The block's logic function calculates
// the circuit gate by gate.
LogicBlock _universalBlock({
  required String displayName,
  required BlockCategory category,
  required List<String> inputLabels,
  required CircuitSpec circuit,
  required String description,
}) {
  return LogicBlock(
    displayName: displayName,
    category: category,
    diagramType: DiagramType.universalCircuit,
    inputLabels: inputLabels,
    outputLabels: const ['Output'],
    description: description,
    computeOutputs: (List<bool> inputValues) =>
        computeCircuitOutputs(circuit, inputLabels, inputValues),
    circuitSpec: circuit,
  );
}

// The six gates built from NAND gates.
final List<LogicBlock> nandGateBlocks = [
  _universalBlock(
    displayName: 'NOT Gate using NAND',
    category: BlockCategory.nandCircuits,
    inputLabels: const ['A'],
    circuit: singleGateAsNotCircuit(GateKind.nand),
    description: 'A NOT gate can be made from one NAND gate. Both inputs of the NAND gate '
        'are joined and connected to A. Since NAND(A, A) = NOT A, the output is '
        'the opposite of A.',
  ),
  _universalBlock(
    displayName: 'AND Gate using NAND',
    category: BlockCategory.nandCircuits,
    inputLabels: const ['A', 'B'],
    circuit: twoGatesInRowCircuit(GateKind.nand),
    description: 'An AND gate can be made from two NAND gates. The first NAND gate takes '
        'A and B. The second NAND gate has its inputs joined, so it works as a '
        'NOT gate and inverts the result of the first. Output = NOT(NAND(A, B)) = '
        'A AND B.',
  ),
  _universalBlock(
    displayName: 'OR Gate using NAND',
    category: BlockCategory.nandCircuits,
    inputLabels: const ['A', 'B'],
    circuit: invertedInputsCircuit(GateKind.nand),
    description: 'An OR gate can be made from three NAND gates. Two of them work as NOT '
        'gates and invert A and B. The third NAND gate combines the inverted '
        'inputs. Output = NAND(NOT A, NOT B) = A OR B.',
  ),
  _universalBlock(
    displayName: 'NOR Gate using NAND',
    category: BlockCategory.nandCircuits,
    inputLabels: const ['A', 'B'],
    circuit: invertedInputsThenNotCircuit(GateKind.nand),
    description: 'A NOR gate can be made from four NAND gates. Three of them form an OR '
        'gate, and the fourth works as a NOT gate that inverts the OR result. '
        'Output = NOT(A OR B) = A NOR B.',
  ),
  _universalBlock(
    displayName: 'XOR Gate using NAND',
    category: BlockCategory.nandCircuits,
    inputLabels: const ['A', 'B'],
    circuit: fourGateCircuit(GateKind.nand),
    description: 'An XOR gate can be made from four NAND gates. The first gate takes A '
        'and B. Its output is then used by the second gate together with A, and '
        'by the third gate together with B. The fourth gate combines these two '
        'results and gives A XOR B.',
  ),
  _universalBlock(
    displayName: 'XNOR Gate using NAND',
    category: BlockCategory.nandCircuits,
    inputLabels: const ['A', 'B'],
    circuit: fourGateThenNotCircuit(GateKind.nand),
    description: 'An XNOR gate can be made from five NAND gates: the four-gate XOR circuit '
        'followed by a fifth NAND gate that works as a NOT gate. The output is 1 '
        'only when A and B are the same.',
  ),
];

// The six gates built from NOR gates.
final List<LogicBlock> norGateBlocks = [
  _universalBlock(
    displayName: 'NOT Gate using NOR',
    category: BlockCategory.norCircuits,
    inputLabels: const ['A'],
    circuit: singleGateAsNotCircuit(GateKind.nor),
    description: 'A NOT gate can be made from one NOR gate. Both inputs of the NOR gate '
        'are joined and connected to A. Since NOR(A, A) = NOT A, the output is '
        'the opposite of A.',
  ),
  _universalBlock(
    displayName: 'OR Gate using NOR',
    category: BlockCategory.norCircuits,
    inputLabels: const ['A', 'B'],
    circuit: twoGatesInRowCircuit(GateKind.nor),
    description: 'An OR gate can be made from two NOR gates. The first NOR gate takes A '
        'and B. The second NOR gate has its inputs joined, so it works as a NOT '
        'gate and inverts the result of the first. Output = NOT(NOR(A, B)) = '
        'A OR B.',
  ),
  _universalBlock(
    displayName: 'AND Gate using NOR',
    category: BlockCategory.norCircuits,
    inputLabels: const ['A', 'B'],
    circuit: invertedInputsCircuit(GateKind.nor),
    description: 'An AND gate can be made from three NOR gates. Two of them work as NOT '
        'gates and invert A and B. The third NOR gate combines the inverted '
        'inputs. Output = NOR(NOT A, NOT B) = A AND B.',
  ),
  _universalBlock(
    displayName: 'NAND Gate using NOR',
    category: BlockCategory.norCircuits,
    inputLabels: const ['A', 'B'],
    circuit: invertedInputsThenNotCircuit(GateKind.nor),
    description: 'A NAND gate can be made from four NOR gates. Three of them form an AND '
        'gate, and the fourth works as a NOT gate that inverts the AND result. '
        'Output = NOT(A AND B) = A NAND B.',
  ),
  _universalBlock(
    displayName: 'XNOR Gate using NOR',
    category: BlockCategory.norCircuits,
    inputLabels: const ['A', 'B'],
    circuit: fourGateCircuit(GateKind.nor),
    description: 'An XNOR gate can be made from four NOR gates. The first gate takes A '
        'and B. Its output is then used by the second gate together with A, and '
        'by the third gate together with B. The fourth gate combines these two '
        'results and gives A XNOR B. The output is 1 only when A and B are the '
        'same.',
  ),
  _universalBlock(
    displayName: 'XOR Gate using NOR',
    category: BlockCategory.norCircuits,
    inputLabels: const ['A', 'B'],
    circuit: fourGateThenNotCircuit(GateKind.nor),
    description: 'An XOR gate can be made from five NOR gates: the four-gate XNOR circuit '
        'followed by a fifth NOR gate that works as a NOT gate. The output is 1 '
        'only when A and B are different.',
  ),
];
