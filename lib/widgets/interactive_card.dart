import 'package:flutter/material.dart';

import '../app/app_theme.dart';
import '../models/logic_block.dart';
import 'led_indicator.dart';
import 'section_card.dart';

// The "Working (Interactive)" card.
// The input LEDs can be tapped to switch them between 0 and 1.
// The output LEDs show the result of the circuit and change instantly.
//
// This widget does not keep any state itself. It only shows the values
// it is given and reports taps. The state lives in BlockSection.
class InteractiveCard extends StatelessWidget {
  final LogicBlock block;

  // Current value of every input (true = 1).
  final List<bool> inputValues;

  // Current value of every output (true = 1).
  final List<bool> outputValues;

  // Called with the index of the input that was tapped.
  final void Function(int inputIndex) onToggleInput;

  // Called when the Reset button is pressed.
  final VoidCallback onReset;

  const InteractiveCard({
    super.key,
    required this.block,
    required this.inputValues,
    required this.outputValues,
    required this.onToggleInput,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = context.palette;

    return SectionCard(
      heading: 'Working (Interactive)',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Tap an input circle to switch it. Red = 0, Green = 1.',
            style: TextStyle(fontSize: 14, color: palette.mutedText),
          ),
          const SizedBox(height: 16),
          _buildSectionTitle('INPUTS', palette),
          const SizedBox(height: 8),
          _buildInputRow(),
          const SizedBox(height: 20),
          _buildSectionTitle('OUTPUTS', palette),
          const SizedBox(height: 8),
          _buildOutputRow(),
          const SizedBox(height: 16),
          Center(
            child: OutlinedButton.icon(
              key: Key('${block.displayName}-reset'),
              onPressed: onReset,
              icon: const Icon(Icons.restart_alt),
              label: const Text('Reset inputs'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String text, AppPalette palette) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 12,
        letterSpacing: 1.5,
        fontWeight: FontWeight.w700,
        color: palette.mutedText,
      ),
    );
  }

  // One tappable LED for every input.
  Widget _buildInputRow() {
    final List<Widget> leds = [];
    for (int i = 0; i < block.inputCount; i++) {
      leds.add(
        LedIndicator(
          key: Key('${block.displayName}-input-$i'),
          isOn: inputValues[i],
          label: block.inputLabels[i],
          onTap: () => onToggleInput(i),
        ),
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: leds,
    );
  }

  // One LED for every output. These have no onTap.
  Widget _buildOutputRow() {
    final List<Widget> leds = [];
    for (int i = 0; i < block.outputCount; i++) {
      leds.add(
        LedIndicator(
          key: Key('${block.displayName}-output-$i'),
          isOn: outputValues[i],
          label: block.outputLabels[i],
        ),
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: leds,
    );
  }
}
