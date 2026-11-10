import 'package:flutter/material.dart';

import '../app/app_theme.dart';
import '../logic/truth_table_builder.dart';
import '../models/logic_block.dart';
import 'section_card.dart';

// Card with the truth table of a block.
// The row that matches the current inputs is highlighted,
// so the table reacts when the user taps the input LEDs.
class TruthTableCard extends StatelessWidget {
  final LogicBlock block;

  // Index of the row to highlight (see rowIndexFromInputs).
  final int highlightedRowIndex;

  const TruthTableCard({
    super.key,
    required this.block,
    required this.highlightedRowIndex,
  });

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = context.palette;
    final List<TruthTableRow> truthTableRows = buildTruthTable(block);

    // Header row: input names, then output names.
    final List<String> headerLabels = [
      ...block.inputLabels,
      ...block.outputLabels,
    ];
    final List<TableRow> tableRows = [
      TableRow(
        children: [
          for (final String label in headerLabels)
            _buildCell(label, palette, isHeader: true),
        ],
      ),
    ];

    // One table row for every combination of inputs.
    for (int rowIndex = 0; rowIndex < truthTableRows.length; rowIndex++) {
      final TruthTableRow row = truthTableRows[rowIndex];
      final bool isHighlighted = rowIndex == highlightedRowIndex;
      final List<bool> allValues = [...row.inputValues, ...row.outputValues];

      tableRows.add(
        TableRow(
          decoration: BoxDecoration(
            color: isHighlighted
                ? palette.primary.withValues(alpha: 0.28)
                : null,
          ),
          children: [
            for (final bool value in allValues)
              _buildCell(value ? '1' : '0', palette, isBold: isHighlighted),
          ],
        ),
      );
    }

    return SectionCard(
      heading: 'Truth Table',
      child: Table(
        key: Key('${block.displayName}-truth-table'),
        border: TableBorder.all(color: palette.tableBorder, width: 1.2),
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: tableRows,
      ),
    );
  }

  // One cell of the table.
  Widget _buildCell(
    String text,
    AppPalette palette, {
    bool isHeader = false,
    bool isBold = false,
  }) {
    final bool useBold = isHeader || isBold;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: isHeader ? 16 : 18,
            fontWeight: useBold ? FontWeight.w800 : FontWeight.w400,
            color: palette.headingText,
          ),
        ),
      ),
    );
  }
}
