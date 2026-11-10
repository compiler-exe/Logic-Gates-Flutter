import 'package:flutter_test/flutter_test.dart';
import 'package:logic_gates_flutter/data/logic_blocks_data.dart';
import 'package:logic_gates_flutter/logic/truth_table_builder.dart';
import 'package:logic_gates_flutter/models/block_category.dart';
import 'package:logic_gates_flutter/models/circuit_spec.dart';
import 'package:logic_gates_flutter/models/gate_kind.dart';
import 'package:logic_gates_flutter/models/logic_block.dart';

// Finds a block by its name, for example 'AND Gate'.
LogicBlock findBlock(String displayName) {
  return allLogicBlocks.firstWhere(
    (LogicBlock block) => block.displayName == displayName,
  );
}

// Turns a truth table into short text rows such as '01:1'.
// The part before ':' is the inputs, the part after is the outputs.
List<String> tableAsText(LogicBlock block) {
  final List<String> textRows = [];
  for (final TruthTableRow row in buildTruthTable(block)) {
    final String inputs = row.inputValues.map((bool v) => v ? '1' : '0').join();
    final String outputs =
        row.outputValues.map((bool v) => v ? '1' : '0').join();
    textRows.add('$inputs:$outputs');
  }
  return textRows;
}

void main() {
  group('gate truth tables', () {
    test('AND', () {
      expect(tableAsText(findBlock('AND Gate')),
          ['00:0', '01:0', '10:0', '11:1']);
    });

    test('OR', () {
      expect(tableAsText(findBlock('OR Gate')),
          ['00:0', '01:1', '10:1', '11:1']);
    });

    test('NOT', () {
      expect(tableAsText(findBlock('NOT Gate')), ['0:1', '1:0']);
    });

    test('NAND', () {
      expect(tableAsText(findBlock('NAND Gate')),
          ['00:1', '01:1', '10:1', '11:0']);
    });

    test('NOR', () {
      expect(tableAsText(findBlock('NOR Gate')),
          ['00:1', '01:0', '10:0', '11:0']);
    });

    test('XOR', () {
      expect(tableAsText(findBlock('XOR Gate')),
          ['00:0', '01:1', '10:1', '11:0']);
    });

    test('XNOR', () {
      expect(tableAsText(findBlock('XNOR Gate')),
          ['00:1', '01:0', '10:0', '11:1']);
    });
  });

  // Each gate built from NAND or NOR gates must give exactly the same
  // truth table as the real gate.
  group('gates built from universal gates', () {
    const List<String> nandTargets = ['NOT', 'AND', 'OR', 'NOR', 'XOR', 'XNOR'];
    const List<String> norTargets = ['NOT', 'OR', 'AND', 'NAND', 'XNOR', 'XOR'];

    test('each NAND circuit equals the real gate', () {
      for (final String target in nandTargets) {
        expect(tableAsText(findBlock('$target Gate using NAND')),
            tableAsText(findBlock('$target Gate')),
            reason: '$target using NAND');
      }
    });

    test('each NOR circuit equals the real gate', () {
      for (final String target in norTargets) {
        expect(tableAsText(findBlock('$target Gate using NOR')),
            tableAsText(findBlock('$target Gate')),
            reason: '$target using NOR');
      }
    });

    test('the circuits have the expected number of gates', () {
      const Map<String, int> expectedNandCounts = {
        'NOT': 1, 'AND': 2, 'OR': 3, 'NOR': 4, 'XOR': 4, 'XNOR': 5,
      };
      const Map<String, int> expectedNorCounts = {
        'NOT': 1, 'OR': 2, 'AND': 3, 'NAND': 4, 'XNOR': 4, 'XOR': 5,
      };
      expectedNandCounts.forEach((String target, int count) {
        expect(findBlock('$target Gate using NAND').circuitSpec!.gates.length,
            count,
            reason: '$target using NAND');
      });
      expectedNorCounts.forEach((String target, int count) {
        expect(findBlock('$target Gate using NOR').circuitSpec!.gates.length,
            count,
            reason: '$target using NOR');
      });
    });

    test('every circuit uses only gates of its own family', () {
      for (final LogicBlock block in allLogicBlocks) {
        final CircuitSpec? circuit = block.circuitSpec;
        if (circuit == null) continue;
        final GateKind expected =
            block.category == BlockCategory.nandCircuits
                ? GateKind.nand
                : GateKind.nor;
        for (final CircuitGateSpec gate in circuit.gates) {
          expect(gate.kind, expected, reason: block.displayName);
        }
      }
    });
  });

  group('adder truth tables (outputs are Sum then Carry)', () {
    test('Half Adder', () {
      expect(tableAsText(findBlock('Half Adder')),
          ['00:00', '01:10', '10:10', '11:01']);
    });

    test('Full Adder', () {
      expect(tableAsText(findBlock('Full Adder')), [
        '000:00',
        '001:10',
        '010:10',
        '011:01',
        '100:10',
        '101:01',
        '110:01',
        '111:11',
      ]);
    });
  });

  group('subtractor truth tables (outputs are Difference then Borrow)', () {
    test('Half Subtractor', () {
      expect(tableAsText(findBlock('Half Subtractor')),
          ['00:00', '01:11', '10:10', '11:00']);
    });

    test('Full Subtractor', () {
      expect(tableAsText(findBlock('Full Subtractor')), [
        '000:00',
        '001:11',
        '010:11',
        '011:01',
        '100:10',
        '101:00',
        '110:00',
        '111:11',
      ]);
    });
  });

  group('block data', () {
    test('there are 23 blocks', () {
      // 7 gates + 6 from NAND + 6 from NOR + 2 adders + 2 subtractors.
      expect(allLogicBlocks.length, 23);
    });

    test('every block has its own name', () {
      final Set<String> names =
          allLogicBlocks.map((LogicBlock b) => b.displayName).toSet();
      expect(names.length, allLogicBlocks.length);
    });

    test('every block has matching label and output counts', () {
      for (final LogicBlock block in allLogicBlocks) {
        final List<bool> inputs = List<bool>.filled(block.inputCount, false);
        expect(block.computeOutputs(inputs).length, block.outputCount,
            reason: block.displayName);
      }
    });
  });
}
