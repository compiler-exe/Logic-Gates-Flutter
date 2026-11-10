import 'package:flutter_test/flutter_test.dart';
import 'package:logic_gates_flutter/data/logic_blocks_data.dart';
import 'package:logic_gates_flutter/models/block_category.dart';
import 'package:logic_gates_flutter/models/ic_pin_info.dart';
import 'package:logic_gates_flutter/models/logic_block.dart';

void main() {
  test('every gate has a 14-pin diagram with GND on pin 7 and VCC on pin 14',
      () {
    for (final LogicBlock block in blocksInCategory(BlockCategory.gates)) {
      final IcPinInfo? pinInfo = block.icPinInfo;
      expect(pinInfo, isNotNull, reason: block.displayName);
      expect(pinInfo!.pinLabels.length, 14, reason: block.displayName);
      expect(pinInfo.pinLabels[6], 'GND', reason: block.displayName);
      expect(pinInfo.pinLabels[13], 'VCC', reason: block.displayName);
    }
  });

  test('the pin diagram IC number matches the block IC number', () {
    for (final LogicBlock block in blocksInCategory(BlockCategory.gates)) {
      expect(block.icPinInfo!.icNumber, block.icNumber,
          reason: block.displayName);
    }
  });

  test('only the seven gates have an IC pin diagram', () {
    for (final LogicBlock block in allLogicBlocks) {
      if (block.category != BlockCategory.gates) {
        expect(block.icPinInfo, isNull, reason: block.displayName);
      }
    }
  });

  test('the IC 7402 (NOR) has its output on pin 1', () {
    final LogicBlock nor =
        allLogicBlocks.firstWhere((LogicBlock b) => b.displayName == 'NOR Gate');
    expect(nor.icPinInfo!.pinLabels[0], '1Y');
    expect(nor.icPinInfo!.pinLabels[1], '1A');
  });

  test('the IC 7404 (NOT) has input 1A on pin 1 and output 1Y on pin 2', () {
    final LogicBlock notGate =
        allLogicBlocks.firstWhere((LogicBlock b) => b.displayName == 'NOT Gate');
    expect(notGate.icPinInfo!.pinLabels[0], '1A');
    expect(notGate.icPinInfo!.pinLabels[1], '1Y');
  });

  test('the IC 74266 (XNOR) has 2Y on pin 4 and 3A on pin 8', () {
    final LogicBlock xnor = allLogicBlocks
        .firstWhere((LogicBlock b) => b.displayName == 'XNOR Gate');
    expect(xnor.icPinInfo!.icNumber, 'IC74266');
    expect(xnor.icPinInfo!.pinLabels[2], '1Y');
    expect(xnor.icPinInfo!.pinLabels[3], '2Y');
    expect(xnor.icPinInfo!.pinLabels[7], '3A');
    expect(xnor.icPinInfo!.pinLabels[10], '4Y');
  });
}
