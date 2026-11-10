import 'package:flutter/material.dart';

// Which point of the text sits on the anchor position.
enum LabelAnchor { left, center, right }

// Draws a piece of text on a canvas.
// The text is centered vertically on [anchorPoint].
// [anchor] decides how the text is placed horizontally:
//   left   - the text starts at the anchor
//   center - the text is centered on the anchor
//   right  - the text ends at the anchor
void drawLabel(
  Canvas canvas,
  String text,
  Offset anchorPoint, {
  required Color color,
  double fontSize = 16,
  FontWeight fontWeight = FontWeight.w600,
  LabelAnchor anchor = LabelAnchor.left,
}) {
  final TextPainter textPainter = TextPainter(
    text: TextSpan(
      text: text,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
    ),
    textDirection: TextDirection.ltr,
  );
  textPainter.layout();

  double left = anchorPoint.dx;
  if (anchor == LabelAnchor.center) {
    left = anchorPoint.dx - textPainter.width / 2;
  } else if (anchor == LabelAnchor.right) {
    left = anchorPoint.dx - textPainter.width;
  }
  final double top = anchorPoint.dy - textPainter.height / 2;
  textPainter.paint(canvas, Offset(left, top));
}
