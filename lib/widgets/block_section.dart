import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../app/app_theme.dart';
import '../logic/truth_table_builder.dart';
import '../models/logic_block.dart';
import 'description_card.dart';
import 'diagram_view.dart';
import 'interactive_card.dart';
import 'pin_diagram_card.dart';
import 'truth_table_card.dart';

// One full section of the app: the heading, the picture, the description,
// the truth table, the interactive demo and (for ICs) the pin diagram.
//
// This widget owns the state of the section: the current value of every
// input. The outputs are never stored. They are calculated from the
// inputs every time the screen is built, so they can never be wrong.
class BlockSection extends StatefulWidget {
  final LogicBlock block;

  const BlockSection({super.key, required this.block});

  @override
  State<BlockSection> createState() => _BlockSectionState();
}

class _BlockSectionState extends State<BlockSection> {
  // Current value of every input. All inputs start at 0 (false).
  late List<bool> inputValues;

  @override
  void initState() {
    super.initState();
    inputValues = List<bool>.filled(widget.block.inputCount, false);
  }

  // Called when the user taps an input LED: flips that input.
  void toggleInput(int inputIndex) {
    HapticFeedback.selectionClick();
    final List<bool> newValues = List<bool>.from(inputValues);
    newValues[inputIndex] = !newValues[inputIndex];
    setState(() {
      inputValues = newValues;
    });
  }

  // Called when the user presses Reset: sets every input back to 0.
  void resetInputs() {
    setState(() {
      inputValues = List<bool>.filled(widget.block.inputCount, false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final LogicBlock block = widget.block;

    // The outputs are calculated from the inputs.
    final List<bool> outputValues = block.computeOutputs(inputValues);
    final int highlightedRowIndex = rowIndexFromInputs(inputValues);

    return Padding(
      padding: const EdgeInsets.only(bottom: 36),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            block.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: context.palette.headingText,
              decoration: TextDecoration.underline,
            ),
          ),
          const SizedBox(height: 8),
          DiagramView(block: block, inputValues: inputValues),
          const SizedBox(height: 8),
          DescriptionCard(block: block),
          const SizedBox(height: 16),
          TruthTableCard(
            block: block,
            highlightedRowIndex: highlightedRowIndex,
          ),
          const SizedBox(height: 16),
          InteractiveCard(
            block: block,
            inputValues: inputValues,
            outputValues: outputValues,
            onToggleInput: toggleInput,
            onReset: resetInputs,
          ),
          if (block.icPinInfo != null) ...[
            const SizedBox(height: 16),
            PinDiagramCard(pinInfo: block.icPinInfo!),
          ],
        ],
      ),
    );
  }
}
