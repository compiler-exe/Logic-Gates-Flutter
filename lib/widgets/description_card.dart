import 'package:flutter/material.dart';

import '../app/app_theme.dart';
import '../models/logic_block.dart';
import 'section_card.dart';

// Card with the written description of a block.
class DescriptionCard extends StatelessWidget {
  final LogicBlock block;

  const DescriptionCard({super.key, required this.block});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      heading: '${block.displayName} Description',
      child: Text(
        block.description,
        style: TextStyle(
          fontSize: 16,
          height: 1.45,
          color: context.palette.bodyText,
        ),
      ),
    );
  }
}
