import 'package:flutter/material.dart';

import '../data/logic_blocks_data.dart';
import '../models/block_category.dart';
import '../models/logic_block.dart';
import '../widgets/block_section.dart';

// The content of the Gates, Adders and Subtractors tabs:
// a scrolling list with one section for every block of the category.
class BlockListTab extends StatefulWidget {
  final BlockCategory category;

  const BlockListTab({super.key, required this.category});

  @override
  State<BlockListTab> createState() => _BlockListTabState();
}

// AutomaticKeepAliveClientMixin keeps the tab alive when the user swipes
// to another tab, so the input values are still there when they come back.
class _BlockListTabState extends State<BlockListTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    // Required by AutomaticKeepAliveClientMixin.
    super.build(context);

    final List<LogicBlock> blocks = blocksInCategory(widget.category);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Column(
        children: [
          for (final LogicBlock block in blocks)
            BlockSection(
              key: ValueKey(block.displayName),
              block: block,
            ),
        ],
      ),
    );
  }
}
