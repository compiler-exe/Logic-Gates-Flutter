import '../logic/logic_functions.dart';
import '../models/block_category.dart';
import '../models/diagram_type.dart';
import '../models/logic_block.dart';
import 'ic_pinouts.dart';
import 'universal_gate_blocks.dart';

// All the circuits of the project, in the order they appear in the app.
// To add a new circuit, add one more LogicBlock to this list.
final List<LogicBlock> allLogicBlocks = [
  // ----------------------------- Gates -----------------------------
  const LogicBlock(
    displayName: 'AND Gate',
    icNumber: 'IC7408',
    category: BlockCategory.gates,
    diagramType: DiagramType.andGate,
    inputLabels: ['A', 'B'],
    outputLabels: ['Output'],
    description: 'An AND gate is a digital logic gate that outputs 1 only '
        'when both of its inputs are 1. Otherwise, it outputs 0.',
    computeOutputs: computeAndGate,
    icPinInfo: ic7408Pins,
  ),
  const LogicBlock(
    displayName: 'OR Gate',
    icNumber: 'IC7432',
    category: BlockCategory.gates,
    diagramType: DiagramType.orGate,
    inputLabels: ['A', 'B'],
    outputLabels: ['Output'],
    description: 'An OR gate is a digital logic gate that outputs 0 only '
        'when both of its inputs are 0. Otherwise, it outputs 1.',
    computeOutputs: computeOrGate,
    icPinInfo: ic7432Pins,
  ),
  const LogicBlock(
    displayName: 'NOT Gate',
    icNumber: 'IC7404',
    category: BlockCategory.gates,
    diagramType: DiagramType.notGate,
    inputLabels: ['A'],
    outputLabels: ['Output'],
    description: 'A NOT gate, also called an inverter, has a single input. '
        'It outputs 1 when the input is 0, and 0 when the input is 1.',
    computeOutputs: computeNotGate,
    icPinInfo: ic7404Pins,
  ),
  const LogicBlock(
    displayName: 'NAND Gate',
    icNumber: 'IC7400',
    category: BlockCategory.gates,
    diagramType: DiagramType.nandGate,
    inputLabels: ['A', 'B'],
    outputLabels: ['Output'],
    description: 'A NAND gate is a digital logic gate that outputs 0 only '
        'when both of its inputs are 1. Otherwise, it outputs 1.',
    computeOutputs: computeNandGate,
    icPinInfo: ic7400Pins,
  ),
  const LogicBlock(
    displayName: 'NOR Gate',
    icNumber: 'IC7402',
    category: BlockCategory.gates,
    diagramType: DiagramType.norGate,
    inputLabels: ['A', 'B'],
    outputLabels: ['Output'],
    description: 'A NOR gate is a digital logic gate that outputs 1 only '
        'when both of its inputs are 0. Otherwise, it outputs 0.',
    computeOutputs: computeNorGate,
    icPinInfo: ic7402Pins,
  ),
  const LogicBlock(
    displayName: 'XOR Gate',
    icNumber: 'IC7486',
    category: BlockCategory.gates,
    diagramType: DiagramType.xorGate,
    inputLabels: ['A', 'B'],
    outputLabels: ['Output'],
    description: 'An XOR gate is a digital logic gate that outputs 1 only '
        'when its two inputs are different. When both inputs are the '
        'same, it outputs 0.',
    computeOutputs: computeXorGate,
    icPinInfo: ic7486Pins,
  ),
  const LogicBlock(
    displayName: 'XNOR Gate',
    icNumber: 'IC74266',
    category: BlockCategory.gates,
    diagramType: DiagramType.xnorGate,
    inputLabels: ['A', 'B'],
    outputLabels: ['Output'],
    description: 'An XNOR gate is a digital logic gate that outputs 1 only '
        'when its two inputs are the same. When the inputs are different, '
        'it outputs 0. It is the opposite of the XOR gate.',
    computeOutputs: computeXnorGate,
    icPinInfo: ic74266Pins,
  ),

  // ------------- Gates built from NAND and NOR gates ---------------
  ...nandGateBlocks,
  ...norGateBlocks,

  // ----------------------------- Adders ----------------------------
  const LogicBlock(
    displayName: 'Half Adder',
    category: BlockCategory.adders,
    diagramType: DiagramType.halfAdder,
    inputLabels: ['A', 'B'],
    outputLabels: ['S', 'C'],
    description: 'A Half Adder adds two single-bit binary inputs, A and B. '
        'It produces a Sum (S) and a Carry (C). The Sum is the XOR of the '
        'inputs, and the Carry is the AND of the inputs.',
    computeOutputs: computeHalfAdder,
  ),
  const LogicBlock(
    displayName: 'Full Adder',
    category: BlockCategory.adders,
    diagramType: DiagramType.fullAdder,
    inputLabels: ['A', 'B', 'Cin'],
    outputLabels: ['S', 'Cout'],
    description: 'A Full Adder adds three single-bit inputs: A, B and '
        'Carry-In (Cin). It produces a Sum (S) and a Carry-Out (Cout). '
        'It is typically built from two Half Adders and an OR gate.',
    computeOutputs: computeFullAdder,
  ),

  // --------------------------- Subtractors -------------------------
  const LogicBlock(
    displayName: 'Half Subtractor',
    category: BlockCategory.subtractors,
    diagramType: DiagramType.halfSubtractor,
    inputLabels: ['A', 'B'],
    outputLabels: ['Difference', 'Borrow'],
    description: 'A Half Subtractor subtracts one single-bit input (B) '
        'from another (A). It produces a Difference and a Borrow. '
        'Difference = A XOR B, and Borrow = NOT(A) AND B.',
    computeOutputs: computeHalfSubtractor,
  ),
  const LogicBlock(
    displayName: 'Full Subtractor',
    category: BlockCategory.subtractors,
    diagramType: DiagramType.fullSubtractor,
    inputLabels: ['A', 'B', 'Bin'],
    outputLabels: ['D', 'Bout'],
    description: 'A Full Subtractor subtracts B and Borrow-In (Bin) from A. '
        'It produces a Difference (D) and a Borrow-Out (Bout). '
        'It is typically built from two Half Subtractors and an OR gate.',
    computeOutputs: computeFullSubtractor,
  ),
];

// Returns only the blocks that belong to one tab.
List<LogicBlock> blocksInCategory(BlockCategory category) {
  final List<LogicBlock> result = [];
  for (final LogicBlock block in allLogicBlocks) {
    if (block.category == category) {
      result.add(block);
    }
  }
  return result;
}
