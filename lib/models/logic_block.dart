import 'block_category.dart';
import 'circuit_spec.dart';
import 'diagram_type.dart';
import 'ic_pin_info.dart';

// A function that takes the input values (true = 1, false = 0)
// and returns the output values.
typedef OutputFunction = List<bool> Function(List<bool> inputValues);

// One circuit of the project: a gate, a gate built from NAND or NOR
// gates, an adder or a subtractor.
// Everything the screen needs to show it lives in this one object.
class LogicBlock {
  // Example: 'AND Gate'.
  final String displayName;

  // Example: 'IC7408'. Only the seven gates have an IC number.
  final String? icNumber;

  final BlockCategory category;

  // Which picture to draw.
  final DiagramType diagramType;

  // Names of the inputs, in order. Example: ['A', 'B'].
  final List<String> inputLabels;

  // Names of the outputs, in order. Example: ['S', 'C'].
  final List<String> outputLabels;

  // The paragraph shown in the description card.
  final String description;

  // Calculates the outputs from the inputs.
  final OutputFunction computeOutputs;

  // Pin diagram of the IC. Null for everything except the seven gates.
  final IcPinInfo? icPinInfo;

  // The gates the circuit is made of. Only the circuits built from NAND
  // or NOR gates have one; for all other blocks this is null.
  final CircuitSpec? circuitSpec;

  const LogicBlock({
    required this.displayName,
    required this.category,
    required this.diagramType,
    required this.inputLabels,
    required this.outputLabels,
    required this.description,
    required this.computeOutputs,
    this.icNumber,
    this.icPinInfo,
    this.circuitSpec,
  });

  int get inputCount => inputLabels.length;

  int get outputCount => outputLabels.length;

  // Heading of the section. Example: 'AND GATE (IC7408)'.
  String get title {
    final String upperName = displayName.toUpperCase();
    if (icNumber == null) {
      return upperName;
    }
    return '$upperName ($icNumber)';
  }
}
