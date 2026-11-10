import '../models/logic_block.dart';

// One row of a truth table: the inputs and the outputs they produce.
class TruthTableRow {
  final List<bool> inputValues;
  final List<bool> outputValues;

  const TruthTableRow({
    required this.inputValues,
    required this.outputValues,
  });
}

// Builds the whole truth table of a block.
// Rows are in normal binary order, with the first input (A) as the
// most significant bit: 00, 01, 10, 11 for two inputs.
// The outputs are calculated by the block itself, so the table can
// never disagree with the interactive LEDs.
List<TruthTableRow> buildTruthTable(LogicBlock block) {
  final int inputCount = block.inputCount;
  final int rowCount = 1 << inputCount; // 2 to the power inputCount
  final List<TruthTableRow> rows = [];

  for (int rowIndex = 0; rowIndex < rowCount; rowIndex++) {
    final List<bool> inputValues = [];
    for (int inputIndex = 0; inputIndex < inputCount; inputIndex++) {
      final int shift = inputCount - 1 - inputIndex;
      final int bit = (rowIndex >> shift) & 1;
      inputValues.add(bit == 1);
    }
    final List<bool> outputValues = block.computeOutputs(inputValues);
    rows.add(TruthTableRow(
      inputValues: inputValues,
      outputValues: outputValues,
    ));
  }
  return rows;
}

// Finds which truth table row matches the current inputs.
// Uses the same binary order as buildTruthTable.
int rowIndexFromInputs(List<bool> inputValues) {
  int rowIndex = 0;
  for (int i = 0; i < inputValues.length; i++) {
    final int bit = inputValues[i] ? 1 : 0;
    rowIndex = rowIndex * 2 + bit;
  }
  return rowIndex;
}
