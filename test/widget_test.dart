import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logic_gates_flutter/app/logic_gates_app.dart';
import 'package:logic_gates_flutter/data/logic_blocks_data.dart';
import 'package:logic_gates_flutter/logic/truth_table_builder.dart';
import 'package:logic_gates_flutter/models/block_category.dart';
import 'package:logic_gates_flutter/models/logic_block.dart';
import 'package:logic_gates_flutter/widgets/led_indicator.dart';

// Opens a tab by tapping its name in the tab bar.
Future<void> openTab(WidgetTester tester, String tabName) async {
  final Finder tabLabel = find.descendant(
    of: find.byType(TabBar),
    matching: find.text(tabName),
  );
  await tester.ensureVisible(tabLabel);
  await tester.pumpAndSettle();
  await tester.tap(tabLabel);
  await tester.pumpAndSettle();
}

// Scrolls a widget into view and taps it.
Future<void> tapKey(WidgetTester tester, Key key) async {
  final Finder finder = find.byKey(key);
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

// Reads whether an LED is on (green) or off (red).
bool isLedOn(WidgetTester tester, Key key) {
  return tester.widget<LedIndicator>(find.byKey(key)).isOn;
}

void main() {
  testWidgets('the app shows the six tabs', (WidgetTester tester) async {
    await tester.pumpWidget(const LogicGatesApp());

    for (final String tabName in [
      'Home',
      'Gates',
      'Using NAND',
      'Using NOR',
      'Adders',
      'Subtractors',
    ]) {
      final Finder tabLabel = find.descendant(
        of: find.byType(TabBar),
        matching: find.text(tabName),
      );
      expect(tabLabel, findsOneWidget, reason: tabName);
    }
  });

  testWidgets('the theme button switches between dark and light mode',
      (WidgetTester tester) async {
    await tester.pumpWidget(const LogicGatesApp());

    Brightness currentBrightness() {
      return Theme.of(tester.element(find.byType(Scaffold).first)).brightness;
    }

    // The app starts in the dark version.
    expect(currentBrightness(), Brightness.dark);

    // Tap an input first, to check that the switch keeps the state.
    await openTab(tester, 'Gates');
    await tapKey(tester, const Key('AND Gate-input-0'));
    expect(isLedOn(tester, const Key('AND Gate-input-0')), true);

    await tester.tap(find.byKey(const Key('theme-toggle')));
    await tester.pumpAndSettle();
    expect(currentBrightness(), Brightness.light);
    expect(isLedOn(tester, const Key('AND Gate-input-0')), true);

    // In the light version the circuits still work.
    await tapKey(tester, const Key('AND Gate-input-1'));
    expect(isLedOn(tester, const Key('AND Gate-output-0')), true);

    await tester.tap(find.byKey(const Key('theme-toggle')));
    await tester.pumpAndSettle();
    expect(currentBrightness(), Brightness.dark);
    expect(isLedOn(tester, const Key('AND Gate-output-0')), true);
  });

  testWidgets('tapping an input LED toggles it and changes the output',
      (WidgetTester tester) async {
    await tester.pumpWidget(const LogicGatesApp());
    await openTab(tester, 'Gates');

    const Key inputA = Key('AND Gate-input-0');
    const Key inputB = Key('AND Gate-input-1');
    const Key output = Key('AND Gate-output-0');

    // At the start every LED is off.
    expect(isLedOn(tester, inputA), false);
    expect(isLedOn(tester, inputB), false);
    expect(isLedOn(tester, output), false);

    // A = 1, B = 0  ->  AND output is still 0.
    await tapKey(tester, inputA);
    expect(isLedOn(tester, inputA), true);
    expect(isLedOn(tester, output), false);

    // A = 1, B = 1  ->  AND output becomes 1.
    await tapKey(tester, inputB);
    expect(isLedOn(tester, inputB), true);
    expect(isLedOn(tester, output), true);

    // Tapping A again switches it back to 0, so the output falls to 0.
    await tapKey(tester, inputA);
    expect(isLedOn(tester, inputA), false);
    expect(isLedOn(tester, output), false);
  });

  testWidgets('a NAND-built XOR gate reacts to taps like a real XOR gate',
      (WidgetTester tester) async {
    await tester.pumpWidget(const LogicGatesApp());
    await openTab(tester, 'Using NAND');

    const Key inputA = Key('XOR Gate using NAND-input-0');
    const Key inputB = Key('XOR Gate using NAND-input-1');
    const Key output = Key('XOR Gate using NAND-output-0');

    expect(isLedOn(tester, output), false);
    await tapKey(tester, inputA);
    expect(isLedOn(tester, output), true);
    await tapKey(tester, inputB);
    expect(isLedOn(tester, output), false);
  });

  testWidgets('the Reset button sets every input back to 0',
      (WidgetTester tester) async {
    await tester.pumpWidget(const LogicGatesApp());
    await openTab(tester, 'Gates');

    await tapKey(tester, const Key('OR Gate-input-0'));
    await tapKey(tester, const Key('OR Gate-input-1'));
    expect(isLedOn(tester, const Key('OR Gate-input-0')), true);
    expect(isLedOn(tester, const Key('OR Gate-input-1')), true);

    await tapKey(tester, const Key('OR Gate-reset'));
    expect(isLedOn(tester, const Key('OR Gate-input-0')), false);
    expect(isLedOn(tester, const Key('OR Gate-input-1')), false);
    expect(isLedOn(tester, const Key('OR Gate-output-0')), false);
  });

  // This test taps every input of every block, so it takes a little longer.
  testWidgets('every block matches its truth table when tapped',
      timeout: const Timeout(Duration(minutes: 5)),
      (WidgetTester tester) async {
    await tester.pumpWidget(const LogicGatesApp());

    for (final BlockCategory category in BlockCategory.values) {
      await openTab(tester, category.label);

      for (final LogicBlock block in blocksInCategory(category)) {
        final String name = block.displayName;

        for (final TruthTableRow row in buildTruthTable(block)) {
          // Start from all zeros, then switch on the inputs that must be 1.
          await tapKey(tester, Key('$name-reset'));
          for (int i = 0; i < block.inputCount; i++) {
            if (row.inputValues[i]) {
              await tapKey(tester, Key('$name-input-$i'));
            }
          }

          // Every output LED must show the value from the truth table.
          for (int i = 0; i < block.outputCount; i++) {
            expect(
              isLedOn(tester, Key('$name-output-$i')),
              row.outputValues[i],
              reason: '$name inputs ${row.inputValues} output $i',
            );
          }
        }
      }
    }
  });
}
