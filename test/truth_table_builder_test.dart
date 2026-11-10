import 'package:flutter_test/flutter_test.dart';
import 'package:logic_gates_flutter/data/logic_blocks_data.dart';
import 'package:logic_gates_flutter/logic/truth_table_builder.dart';
import 'package:logic_gates_flutter/models/logic_block.dart';

void main() {
  test('a table has 2 to the power of inputCount rows', () {
    for (final LogicBlock block in allLogicBlocks) {
      final int expectedRows = 1 << block.inputCount;
      expect(buildTruthTable(block).length, expectedRows,
          reason: block.displayName);
    }
  });

  test('the first row is all zeros and the last row is all ones', () {
    for (final LogicBlock block in allLogicBlocks) {
      final List<TruthTableRow> rows = buildTruthTable(block);
      expect(rows.first.inputValues.every((bool v) => v == false), true,
          reason: block.displayName);
      expect(rows.last.inputValues.every((bool v) => v == true), true,
          reason: block.displayName);
    }
  });

  test('rowIndexFromInputs finds the right row', () {
    expect(rowIndexFromInputs([false, false]), 0);
    expect(rowIndexFromInputs([false, true]), 1);
    expect(rowIndexFromInputs([true, false]), 2);
    expect(rowIndexFromInputs([true, true]), 3);
    expect(rowIndexFromInputs([true, false, true]), 5);
  });

  test('rowIndexFromInputs agrees with the table order', () {
    for (final LogicBlock block in allLogicBlocks) {
      final List<TruthTableRow> rows = buildTruthTable(block);
      for (int i = 0; i < rows.length; i++) {
        expect(rowIndexFromInputs(rows[i].inputValues), i,
            reason: block.displayName);
      }
    }
  });
}
