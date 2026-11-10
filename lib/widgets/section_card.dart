import 'package:flutter/material.dart';

import '../app/app_theme.dart';

// The rounded card with a heading. Every part of a section
// (description, truth table, interactive demo, pin diagram) uses it.
class SectionCard extends StatelessWidget {
  final String heading;
  final Widget child;

  const SectionCard({
    super.key,
    required this.heading,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = context.palette;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: palette.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: palette.cardBorder),
        boxShadow: [
          BoxShadow(
            color: palette.cardShadow,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            heading,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: palette.headingText,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
